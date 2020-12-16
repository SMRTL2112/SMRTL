DECLARE
  
v_diag_rec Err.DiagRec;  
v_err_msg varchar2(2000);
v_Mail_Host constant VARCHAR2(30) := '192.168.102.55';-- IP of email server
v_Mail_Conn utl_smtp.Connection;
--v_dt VARCHAR2(30):=to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss');
v_dt VARCHAR2(60):=to_char(systimestamp, 'Dy, DD Mon YYYY hh24:mi:ss TZH:TZM','NLS_DATE_LANGUAGE=ENGLISH');

v_boundary varchar2(40);
v_reply utl_smtp.reply;

v_last_serial varchar2(60) := '';
v_from constant varchar2(30) := 'mailbot@smrtl.org';
v_reply_to constant varchar2(30) := 'bloodLab@smrtl.org';
v_error_email varchar2(2000);

v_filename varchar2(50);
v_filename_txt varchar2(50);
v_exists boolean;
v_exists_txt boolean;
v_filesize number;
v_blocksize number;
v_no_logger boolean;
v_tmon_serial varchar2(300);

function add_file(p_directory in varchar2, p_filename in varchar2) return boolean as
v_file bfile;
v_length binary_integer := 0;
v_buffer_size integer := 10080;
v_raw raw(10080);
i integer := 1;

begin
  
  v_file := bfilename(p_directory, p_filename);

  begin
    dbms_lob.fileopen(v_file, dbms_lob.file_readonly);
  exception
  when DBMS_LOB.NOEXIST_DIRECTORY then
    dbms_output.put_line('Oracle directory ' || p_directory || ' does not exist');
    return false;
  when DBMS_LOB.UNOPENED_FILE then
    dbms_output.put_line('Unopened file');
    return false;
  when DBMS_LOB.ACCESS_ERROR then
    dbms_output.put_line('Access error');
    return false;
  when DBMS_LOB.OPERATION_FAILED then
    dbms_output.put_line('Operation Failed, does file '|| p_filename || ' exist?');
    return false;
  when others then
    dbms_output.put_line('Unknown error attempting to read file '||p_filename);
    return false;
  end;


  v_length := dbms_lob.getlength(v_file);

  if v_length > 0 then

    utl_smtp.write_data(v_mail_conn,'--' || v_boundary ||utl_tcp.crlf);
    utl_smtp.write_data(v_mail_conn,'Content-Type: applicaton/pdf' || utl_tcp.crlf);
    utl_smtp.write_data(v_mail_conn,'Content-Disposition: attachment; filename="' || p_filename || '"' || utl_tcp.crlf);
    utl_smtp.write_data(v_mail_conn,'Content-Transfer-Encoding: base64' || utl_tcp.crlf || utl_tcp.crlf);

    while i < v_length loop
      dbms_lob.read(v_file, v_buffer_size, i, v_raw);
      utl_smtp.write_raw_data(v_mail_conn, utl_encode.base64_encode(v_raw));
      utl_smtp.write_data(v_mail_conn, utl_tcp.crlf);
      i := i + v_buffer_size;  
    end loop;
  end if;

  dbms_lob.fileclose(v_file);

return true;

end;

BEGIN

-- Set level of diagnostic record to 0
v_diag_rec.LVL := 0;

Err.StartHeader(v_diag_rec,'EMAIL_TMN','****',v_err_msg);
Err.Msg('Starting EMAIL_TMON',0,600000,v_diag_rec);

-- Loop through samples with open RCPTREPORT schedules, populated TMON auxdata, and with map_to_addrs recipient with flag 5 set to 'T' and delivery_method of 'E'
--- group by distinct temp monitors
--- for each temp monitor number look for a matching file in oracle directory indicated in address aux_data
--- send one email per temp monitor stating which samples were received with it
--- If all is successful post the RCPTREPORT schedule
for r_logger in (
  select distinct ad1.aux_data "TMON_MAKE"
     , ad2.aux_data "TMON_SERIAL"
     , ad.e_mail
     , ad3.aux_data "OUTBOX"
     , ad4.aux_data "SENT"
     , trunc(sa.receive_date) "RCPT_DATE"
     , decode(substr(mta.delivery_methods,3,1),'E',1,0) "EMAIL_DELIVERY"
     , decode(substr(mta.delivery_methods,6,1),'W',1,0) "FTP_DELIVERY"
  from samples sa
    inner join profiles p on p.reqnbr = sa.reqnbr
    inner join aux_data ad1 on ad1.aux_data_id= sa.hsn and ad1.aux_data_type = 'S' and ad1.aux_data_format = 'TMON' and ad1.aux_field = 1
    inner join aux_data ad2 on ad2.aux_data_id= sa.hsn and ad2.aux_data_type = 'S' and ad2.aux_data_format = 'TMON' and ad2.aux_field = 2
    inner join map_to_addrs mta on mta.cust_id = p.cust_id and nvl(mta.reqnbr,p.reqnbr) = p.reqnbr and substr(mta.flags,5,1) = 'T' and (substr(mta.delivery_methods,3,1) = 'E' or substr(mta.delivery_methods,6,1) = 'W')
    inner join addresses ad on ad.addr_Seq= mta.addr_seq
    inner join aux_data ad3 on ad3.aux_data_id = ad.addr_seq and ad3.aux_data_type = 'A' and ad3.aux_Data_format = 'COLD' and ad3.aux_field = 1
    inner join aux_data ad4 on ad4.aux_data_id = ad.addr_seq and ad4.aux_data_type = 'A' and ad4.aux_Data_format = 'COLD' and ad4.aux_field = 2
  where trunc(sa.receive_date) >= trunc(sysdate-21)
    and ad4.aux_data IN ('USADA_SENT')
    and ad1.aux_data = 'LogTag'
    and ad2.aux_data IN ('1000819914')) loop --IN ('CLEARIDIUM_SENT','UCI_SENT','USADA_SENT','DFS_SENT','IDTM_SENT','PWC_SENT')
  
    v_no_logger := false;
    
    v_exists_txt := false;
  
    if r_logger.tmon_make = 'LIBERO' then
      v_filename := initcap(r_logger.tmon_make) || r_logger.tmon_serial || '_' || to_char(r_logger.RCPT_DATE,'YYYY-MM-DD') || '.pdf';
    elsif r_logger.tmon_make = 'NO_MONITOR' then
      v_no_logger := true;
    elsif r_logger.tmon_make = 'ESCORT' then
      if (instr(r_logger.tmon_serial,'-') = 0) then
        v_tmon_serial := substr(r_logger.tmon_serial,1,2)||'-'||substr(r_logger.tmon_serial,3,2)||'-'||substr(r_logger.tmon_serial,5,4)||'-'||substr(r_logger.tmon_serial,9,4);
        v_filename := v_tmon_serial || '_' || to_char(r_logger.RCPT_DATE,'YYYY-MM-DD') || '.lcf';
        v_filename_txt := v_tmon_serial || '_' || to_char(r_logger.RCPT_DATE,'YYYY-MM-DD') || '.txt';
      else
        -- Alternately look for *.pdf?
        v_filename := r_logger.tmon_serial || '_' || to_char(r_logger.RCPT_DATE,'YYYY-MM-DD') || '.lcf';
        v_filename_txt := r_logger.tmon_serial || '_' || to_char(r_logger.RCPT_DATE,'YYYY-MM-DD') || '.txt';
      --v_filename := r_logger.tmon_serial || '_TEST.lcf';
      end if;
    elsif r_logger.tmon_make = 'LogTag' then
      -- LogTag temperature monitors are single use - they need no date in the file name
      v_filename := r_logger.tmon_serial ||'_'|| to_char(r_logger.RCPT_DATE,'YYYY-MM-DD') || '.ltd';
      v_filename_txt := r_logger.tmon_serial ||'_'|| to_char(r_logger.RCPT_DATE,'YYYY-MM-DD') || '.txt';
    elsif r_logger.tmon_make = 'QTAG' then
      v_filename := r_logger.tmon_serial || '_' || to_char(r_logger.RCPT_DATE,'YYYY-MM-DD') || '.pdf';
    elsif r_logger.tmon_make = 'TEMPTALE' then
      v_filename := r_logger.tmon_serial || '_' || to_char(r_logger.RCPT_DATE,'YYYY-MM-DD') || '.pdf';
    elsif r_logger.tmon_make = 'TempSen' then
      v_filename := r_logger.tmon_serial || '_' || to_char(r_logger.RCPT_DATE,'YYYY-MM-DD') || '.pdf';
    elsif r_logger.tmon_make = 'CRYOPAK' then
      v_filename := replace(r_logger.tmon_serial,' ') || '_' || to_char(r_logger.RCPT_DATE,'YYYY-MM-DD') || '.pdf';
    else
      v_filename := 'UNKNOWN';
    end if;

    if not v_no_logger then    
      dbms_output.put_line('Looking for file ' || v_filename || ' in folder: ' ||r_logger.outbox);
      Err.Msg('Looking for file for logger ' || r_logger.tmon_make || ' ' || r_logger.tmon_serial,0,600001,v_diag_rec);   
      utl_file.fgetattr(r_logger.outbox, v_filename,v_exists,v_filesize,v_blocksize);

      -- Try looking for pdf
      if not v_exists and substr(v_filename,-3,3) = 'lcf' then
        v_filename := replace(v_filename,'lcf','pdf');
        dbms_output.put_line('Looking for file ' || v_filename || ' in folder: ' ||r_logger.outbox);
        Err.Msg('Looking for file for logger ' || r_logger.tmon_make || ' ' || r_logger.tmon_serial,0,600001,v_diag_rec);   
        utl_file.fgetattr(r_logger.outbox, v_filename,v_exists,v_filesize,v_blocksize);
      elsif not v_exists and substr(v_filename,-3,3) = 'ltd' then
        v_filename := replace(v_filename,'ltd','pdf');
        dbms_output.put_line('Looking for file ' || v_filename || ' in folder: ' ||r_logger.outbox);
        Err.Msg('Looking for file for logger ' || r_logger.tmon_make || ' ' || r_logger.tmon_serial,0,600001,v_diag_rec);   
        utl_file.fgetattr(r_logger.outbox, v_filename,v_exists,v_filesize,v_blocksize);
      end if;
      
      if r_logger.sent = 'USADA_SENT' then
        utl_file.fgetattr(r_logger.outbox, v_filename_txt,v_exists_txt,v_filesize,v_blocksize);
      end if;
    end if;

    if v_exists or v_no_logger then    
      if v_exists then
        Err.Msg('Found logger file ' || v_filename || ' in Oracle directory ' || r_logger.outbox,0,600001,v_diag_rec);
      end if;

      -- If FTP Delivery then move the file to the "SENT" folder without emailing it; the FTP process will grab it from there.
      if r_logger.ftp_delivery = 1 then        
--        for r_schedule in (
--          select sa.hsn, sa.original_coc, sa.collect_date, sa.receive_date, sc.schedule_seq
--          from samples sa
--          inner join schedules sc on sc.schedule_id = sa.hsn and sc.schedule_type = 'S' and sc.active_flag = 'A' and sc.proc_code = 'RCPTREPORT'
--          inner join profiles p on p.reqnbr = sa.reqnbr
--          inner join aux_data ad1 on ad1.aux_data_id= sa.hsn and ad1.aux_data_type = 'S' and ad1.aux_data_format = 'TMON' and ad1.aux_field = 1
--          inner join aux_data ad2 on ad2.aux_data_id= sa.hsn and ad2.aux_data_type = 'S' and ad2.aux_data_format = 'TMON' and ad2.aux_field = 2
--          inner join map_to_addrs mta on mta.cust_id = p.cust_id and nvl(mta.reqnbr,p.reqnbr) = p.reqnbr and substr(mta.flags,5,1) = 'T' and substr(mta.delivery_methods,6,1) = 'W'
--          inner join addresses ad on ad.addr_Seq= mta.addr_seq
--          inner join aux_data ad3 on ad3.aux_data_id = ad.addr_seq and ad3.aux_data_type = 'A' and ad3.aux_Data_format = 'COLD' and ad3.aux_field = 1
--          inner join aux_data ad4 on ad4.aux_data_id = ad.addr_seq and ad4.aux_data_type = 'A' and ad4.aux_Data_format = 'COLD' and ad4.aux_field = 2
--          where ad1.aux_data = r_logger.tmon_make 
--          and ad2.aux_data = r_logger.tmon_serial
--          and trunc(sa.receive_date) = r_logger.RCPT_DATE) loop

--          if posting.post_schedule(r_schedule.schedule_seq, 'MBOO', to_char(sysdate,'MM/DD/YYYY HH24:MI'),'OK',null,1,0,v_err_msg) = 0 then
--            dbms_output.put_line('Problem posting RCTPREPORT on sample ' || r_schedule.hsn || '. ' || v_err_msg);
--            Err.Msg('Error posting RCPTREPORT schedule ' || r_schedule.schedule_seq || ' on sample ' || r_schedule.hsn||'. '||v_err_msg,0,600001,v_diag_rec);
--            email_admin('Error posting RCPTREPORT on Lab ID: '|| r_schedule.hsn,'Procedure EMAIL_TMON encountered an error posting the RCPTREPORT schedule ' || r_schedule.schedule_seq || ' on sample ' || r_schedule.hsn);
--          else
--            dbms_output.put_line('Posted RCPTREPORT on sample ' || r_schedule.hsn);
--            Err.Msg('Posted RCPTREPORT schedule ' || r_schedule.schedule_seq || ' on sample ' || r_schedule.hsn,0,600001,v_diag_rec);
--          end if;
--        end loop;
        
        if v_exists then
          begin
            utl_file.frename(r_logger.outbox, v_filename, r_logger.sent, v_filename, TRUE);
            dbms_output.put_line('File moved to Oracle directory: '|| r_logger.sent);
            Err.Msg('File ' || v_filename || ' moved to Oracle directory ' || r_logger.sent,0,600001,v_diag_rec);
          exception
          when others then
            email_admin('Error moving temp logger file: ' || v_filename,'Procedure EMAIL_TMON encountered an error trying to move the file ' || v_filename || ' from ' || r_logger.outbox || ' to ' || r_logger.sent);
          end;
          
          if v_exists_txt then
                begin            
                  utl_file.frename(r_logger.outbox, v_filename_txt, r_logger.sent, v_filename_txt, TRUE);
                  dbms_output.put_line('TXT File moved to Oracle directory: '|| r_logger.sent);
                  Err.Msg('File ' || v_filename_txt || ' moved to Oracle directory ' || r_logger.sent,0,600001,v_diag_rec);
                exception
                when others then
                  email_admin('Error moving TXT temp logger file: ' || v_filename_txt,'Procedure EMAIL_TMON encountered an error trying to move the file ' || v_filename_txt || ' from ' || r_logger.outbox || ' to ' || r_logger.sent);
                end;
              end if;
          
        end if;
      else
        v_boundary := dbms_crypto.hash(to_clob(to_char(sysdate,'MM/DD/YYYY')||r_logger.tmon_serial),3);
        v_Mail_Conn := utl_smtp.Open_Connection(v_Mail_Host, 25);
      
        utl_smtp.Helo(v_Mail_Conn, v_Mail_Host);
        utl_smtp.Mail(v_Mail_Conn, v_from);
        utl_smtp.Rcpt(v_Mail_Conn, r_logger.e_mail);
        -- Following is effectively a BCC
        utl_smtp.Rcpt(v_Mail_Conn, 'mbooth@smrtl.org');
      
        utl_smtp.open_data(v_Mail_Conn);
        utl_smtp.write_data(v_mail_conn,'Date: ' || v_dt || utl_tcp.crlf);
        utl_smtp.write_data(v_mail_conn,'From: ' || v_from || utl_tcp.crlf);
        utl_smtp.write_data(v_mail_conn,'Reply-To: ' || v_reply_to || utl_tcp.crlf);
        
        if r_logger.tmon_make = 'TEMPTALE' then
            utl_smtp.write_data(v_mail_conn,'Subject: Temptale logger received; no report available' || utl_tcp.crlf);
        elsif r_logger.tmon_make = 'NO_MONITOR' then
            utl_smtp.write_data(v_mail_conn,'Subject: No temperature monitor received' || utl_tcp.crlf);
        else
          utl_smtp.write_data(v_mail_conn,'Subject: Temperature monitor report for logger: ' || r_logger.tmon_make || ' ' || r_logger.tmon_serial || utl_tcp.crlf);
        end if;
        
        utl_smtp.write_data(v_Mail_Conn, 'To: ''' || r_logger.e_mail || '''' || utl_tcp.crlf);
        --utl_smtp.write_data(v_mail_conn,'To: ' || 'mykejm@gmail.com' || utl_tcp.crlf);
      
        utl_smtp.write_data(v_mail_conn,'MIME-Version: 1.0'|| utl_tcp.crlf);
        utl_smtp.write_data(v_mail_conn,'Content-Type: multipart/mixed; boundary=' || v_boundary || utl_tcp.crlf || utl_tcp.crlf);
      
        utl_smtp.write_data(v_mail_conn,'--' || v_boundary ||utl_tcp.crlf);
        utl_smtp.write_data(v_mail_conn,'Content-Type: text/plain; charset="iso-8859-1"' || utl_tcp.crlf || utl_tcp.crlf);
        
        if r_logger.tmon_make = 'TEMPTALE' then
          utl_smtp.write_data(v_mail_conn,'A Temptale temperature logger was received with the following samples: ' || utl_tcp.crlf||utl_tcp.crlf);
        elsif r_logger.tmon_make = 'NO_MONITOR' then
          utl_smtp.write_data(v_mail_conn,'No temperature logger was received with the following samples: ' || utl_tcp.crlf||utl_tcp.crlf);
        else
          utl_smtp.write_data(v_mail_conn,'Attached is the temperature monitor report for logger ' || r_logger.tmon_make || ' ' || r_logger.tmon_serial || '. The following samples are associated with this logger: ' || utl_tcp.crlf||utl_tcp.crlf);
        end if;
        utl_smtp.write_data(v_mail_conn,'Sample         '||chr(9)||'Collection Date'||utl_tcp.crlf);
    
    --Err.Msg('Creating email message to ' || p_recipient || ' with Cc sent to ' || p_cc,0,600001,v_diag_rec);
    
        for r_sample in (
          select sa.hsn, sa.original_coc, sa.collect_date, sa.receive_date
          from samples sa
          inner join profiles p on p.reqnbr = sa.reqnbr
          inner join aux_data ad1 on ad1.aux_data_id= sa.hsn and ad1.aux_data_type = 'S' and ad1.aux_data_format = 'TMON' and ad1.aux_field = 1
          inner join aux_data ad2 on ad2.aux_data_id= sa.hsn and ad2.aux_data_type = 'S' and ad2.aux_data_format = 'TMON' and ad2.aux_field = 2
          inner join map_to_addrs mta on mta.cust_id = p.cust_id and nvl(mta.reqnbr,p.reqnbr) = p.reqnbr and substr(mta.flags,5,1) = 'T' and substr(mta.delivery_methods,3,1) = 'E'
          inner join addresses ad on ad.addr_Seq= mta.addr_seq
          inner join aux_data ad3 on ad3.aux_data_id = ad.addr_seq and ad3.aux_data_type = 'A' and ad3.aux_Data_format = 'COLD' and ad3.aux_field = 1
          inner join aux_data ad4 on ad4.aux_data_id = ad.addr_seq and ad4.aux_data_type = 'A' and ad4.aux_Data_format = 'COLD' and ad4.aux_field = 2
          where ad1.aux_data = r_logger.tmon_make 
          and exists (Select 1 from schedules where proc_code = 'RCPTREPORT' and active_flag = 'A' and schedule_id = sa.hsn and schedule_type = 'S')
          and ad2.aux_data = r_logger.tmon_serial
          and trunc(sa.receive_date) = r_logger.RCPT_DATE) loop
        
          utl_smtp.write_data(v_mail_conn,rpad(r_sample.original_coc,15)||chr(9)||to_char(r_sample.collect_date,'DD-MON-YYYY')||utl_tcp.crlf);       
          Err.Msg('Sample ' || r_sample.original_coc || ' added to email for logger ' || r_logger.tmon_make || ' ' || r_logger.tmon_serial,0,600001,v_diag_rec);
          
        end loop;
        
          if v_exists then
            if add_file(r_logger.outbox, v_filename) then
              dbms_output.put_line('Added file');
              
              if v_exists_txt then
                if add_file(r_logger.outbox, v_filename_txt) then
                  dbms_output.put_line('Added USADA .txt file');
                end if;
              end if;
            end if;
          end if;
          
          utl_smtp.write_data(v_mail_conn,'--' || v_boundary || '--' || utl_tcp.crlf || utl_tcp.crlf);
          v_reply := utl_smtp.close_data(v_mail_conn);
          
          dbms_output.put_line('SMTP close_data reply: '|| v_reply.code || ' - ' || v_reply.text);        
          utl_smtp.Quit(v_mail_conn);
        
          if v_reply.code = 250 then
            Err.Msg('Email sent successfully to '||r_logger.e_mail,0,600001,v_diag_rec);          
            --Err.Msg('Email sent successfully to '||'mykejm@gmail.com',0,600001,v_diag_rec);          
  
            -- Post schedules, move file
--            for r_schedule in (
--              select sa.hsn, sa.original_coc, sa.collect_date, sa.receive_date, sc.schedule_seq
--              from samples sa
--              inner join schedules sc on sc.schedule_id = sa.hsn and sc.schedule_type = 'S' and sc.active_flag = 'A' and sc.proc_code = 'RCPTREPORT'
--              inner join profiles p on p.reqnbr = sa.reqnbr
--              inner join aux_data ad1 on ad1.aux_data_id= sa.hsn and ad1.aux_data_type = 'S' and ad1.aux_data_format = 'TMON' and ad1.aux_field = 1
--              inner join aux_data ad2 on ad2.aux_data_id= sa.hsn and ad2.aux_data_type = 'S' and ad2.aux_data_format = 'TMON' and ad2.aux_field = 2
--              inner join map_to_addrs mta on mta.cust_id = p.cust_id and nvl(mta.reqnbr,p.reqnbr) = p.reqnbr and substr(mta.flags,5,1) = 'T' and substr(mta.delivery_methods,3,1) = 'E' 
--              inner join addresses ad on ad.addr_Seq= mta.addr_seq
--              inner join aux_data ad3 on ad3.aux_data_id = ad.addr_seq and ad3.aux_data_type = 'A' and ad3.aux_Data_format = 'COLD' and ad3.aux_field = 1
--              inner join aux_data ad4 on ad4.aux_data_id = ad.addr_seq and ad4.aux_data_type = 'A' and ad4.aux_Data_format = 'COLD' and ad4.aux_field = 2
--              where ad1.aux_data = r_logger.tmon_make 
--              and trunc(sa.receive_date) = r_logger.RCPT_DATE
--              and ad2.aux_data = r_logger.tmon_serial) loop
--  
--  
--              if posting.post_schedule(r_schedule.schedule_seq, 'MBOO', to_char(sysdate,'MM/DD/YYYY HH24:MI'),'OK',null,1,0,v_err_msg) = 0 then
--              --if posting.post_schedule(r_schedule.schedule_seq, 'MMAD', to_char(sysdate,'MM/DD/YYYY HH24:MI'),'--',null,1,0,v_err_msg) = 0 then
--                dbms_output.put_line('Problem posting RCTPREPORT on sample ' || r_schedule.hsn || '. ' || v_err_msg);
--                Err.Msg('Error posting RCPTREPORT schedule ' || r_schedule.schedule_seq || ' on sample ' || r_schedule.hsn||'. '||v_err_msg,0,600001,v_diag_rec);
--                email_admin('Error posting RCPTREPORT on Lab ID: '|| r_schedule.hsn,'Procedure EMAIL_TMON encountered an error posting the RCPTREPORT schedule ' || r_schedule.schedule_seq || ' on sample ' || r_schedule.hsn);
--              else
--                dbms_output.put_line('Posted RCPTREPORT on sample ' || r_schedule.hsn);
--                Err.Msg('Posted RCPTREPORT schedule ' || r_schedule.schedule_seq || ' on sample ' || r_schedule.hsn,0,600001,v_diag_rec);
--              end if;
--            end loop;
                        
            -- If we can't post or send file, send an email to LIMS admins?
            
            if v_exists then
              begin            
                utl_file.frename(r_logger.outbox, v_filename, r_logger.sent, v_filename, TRUE);
                --utl_file.frename(r_logger.outbox, v_filename, 'TEST', v_filename, TRUE);
                dbms_output.put_line('File moved to Oracle directory: '|| r_logger.sent);
                Err.Msg('File ' || v_filename || ' moved to Oracle directory ' || r_logger.sent,0,600001,v_diag_rec);
              exception
              when others then
                email_admin('Error moving temp logger file: ' || v_filename,'Procedure EMAIL_TMON encountered an error trying to move the file ' || v_filename || ' from ' || r_logger.outbox || ' to ' || r_logger.sent);
              end;
              
              if v_exists_txt then
                begin            
                  utl_file.frename(r_logger.outbox, v_filename_txt, r_logger.sent, v_filename_txt, TRUE);
                  --utl_file.frename(r_logger.outbox, v_filename, 'TEST', v_filename, TRUE);
                  dbms_output.put_line('TXT File moved to Oracle directory: '|| r_logger.sent);
                  Err.Msg('File ' || v_filename_txt || ' moved to Oracle directory ' || r_logger.sent,0,600001,v_diag_rec);
                exception
                when others then
                  email_admin('Error moving TXT temp logger file: ' || v_filename_txt,'Procedure EMAIL_TMON encountered an error trying to move the file ' || v_filename_txt || ' from ' || r_logger.outbox || ' to ' || r_logger.sent);
                end;
              end if;
              
            end if;
          else
            Err.Msg('Email not sent. SMTP status: '||v_reply.code || ' - ' || v_reply.text,0,600001,v_diag_rec);
          end if;               
          Err.EndHeader(v_Diag_Rec);               
      end if;        
    else
        -- If no file found then don't send email, but post schedule with error code
        dbms_output.put_line('File not found, no email sent.');        
        Err.Msg('No file found, email not sent.',0,600001,v_diag_rec);

--        for r_schedule in (
--              select sa.hsn, sa.original_coc, sa.collect_date, sa.receive_date, sc.schedule_seq
--              from samples sa
--              inner join schedules sc on sc.schedule_id = sa.hsn and sc.schedule_type = 'S' and sc.active_flag = 'A' and sc.proc_code = 'RCPTREPORT'
--              inner join profiles p on p.reqnbr = sa.reqnbr
--              inner join aux_data ad1 on ad1.aux_data_id= sa.hsn and ad1.aux_data_type = 'S' and ad1.aux_data_format = 'TMON' and ad1.aux_field = 1
--              inner join aux_data ad2 on ad2.aux_data_id= sa.hsn and ad2.aux_data_type = 'S' and ad2.aux_data_format = 'TMON' and ad2.aux_field = 2
--              inner join map_to_addrs mta on mta.cust_id = p.cust_id and nvl(mta.reqnbr,p.reqnbr) = p.reqnbr and substr(mta.flags,5,1) = 'T' and substr(mta.delivery_methods,6,1) = 'W'
--              inner join addresses ad on ad.addr_Seq= mta.addr_seq
--              inner join aux_data ad3 on ad3.aux_data_id = ad.addr_seq and ad3.aux_data_type = 'A' and ad3.aux_Data_format = 'COLD' and ad3.aux_field = 1
--              inner join aux_data ad4 on ad4.aux_data_id = ad.addr_seq and ad4.aux_data_type = 'A' and ad4.aux_Data_format = 'COLD' and ad4.aux_field = 2
--              where ad1.aux_data = r_logger.tmon_make 
--              and trunc(sa.receive_date) = r_logger.RCPT_DATE
--              and ad2.aux_data = r_logger.tmon_serial
--              UNION
--              select sa.hsn, sa.original_coc, sa.collect_date, sa.receive_date, sc.schedule_seq
--              from samples sa
--              inner join schedules sc on sc.schedule_id = sa.hsn and sc.schedule_type = 'S' and sc.active_flag = 'A' and sc.proc_code = 'RCPTREPORT'
--              inner join profiles p on p.reqnbr = sa.reqnbr
--              inner join aux_data ad1 on ad1.aux_data_id= sa.hsn and ad1.aux_data_type = 'S' and ad1.aux_data_format = 'TMON' and ad1.aux_field = 1
--              inner join aux_data ad2 on ad2.aux_data_id= sa.hsn and ad2.aux_data_type = 'S' and ad2.aux_data_format = 'TMON' and ad2.aux_field = 2
--              inner join map_to_addrs mta on mta.cust_id = p.cust_id and nvl(mta.reqnbr,p.reqnbr) = p.reqnbr and substr(mta.flags,5,1) = 'T' and substr(mta.delivery_methods,3,1) = 'E'
--              inner join addresses ad on ad.addr_Seq= mta.addr_seq
--              inner join aux_data ad3 on ad3.aux_data_id = ad.addr_seq and ad3.aux_data_type = 'A' and ad3.aux_Data_format = 'COLD' and ad3.aux_field = 1
--              inner join aux_data ad4 on ad4.aux_data_id = ad.addr_seq and ad4.aux_data_type = 'A' and ad4.aux_Data_format = 'COLD' and ad4.aux_field = 2
--              where ad1.aux_data = r_logger.tmon_make 
--              and trunc(sa.receive_date) = r_logger.RCPT_DATE
--              and ad2.aux_data = r_logger.tmon_serial
--              ) loop
--
--              if posting.post_schedule(r_schedule.schedule_seq, 'MBOO', to_char(sysdate,'MM/DD/YYYY HH24:MI'),'FM',null,1,0,v_err_msg) = 0 then
--              --if posting.post_schedule(r_schedule.schedule_seq, 'MMAD', to_char(sysdate,'MM/DD/YYYY HH24:MI'),'--',null,1,0,v_err_msg) = 0 then
--                dbms_output.put_line('Problem posting RCTPREPORT on sample ' || r_schedule.hsn || '. ' || v_err_msg);
--                Err.Msg('Error posting RCPTREPORT schedule ' || r_schedule.schedule_seq || ' on sample ' || r_schedule.hsn||'. '||v_err_msg,0,600001,v_diag_rec);
--                email_admin('Error posting RCPTREPORT on Lab ID: '|| r_schedule.hsn,'Procedure EMAIL_TMON encountered an error posting the RCPTREPORT schedule ' || r_schedule.schedule_seq || ' on sample ' || r_schedule.hsn);
--              else
--                dbms_output.put_line('Posted RCPTREPORT on sample ' || r_schedule.hsn);
--                Err.Msg('Posted RCPTREPORT schedule ' || r_schedule.schedule_seq || ' on sample ' || r_schedule.hsn,0,600001,v_diag_rec);
--              end if;
--        end loop;


        v_error_email := 'Failed to find temp logger file ' || v_filename || ' associated with the following samples: '||chr(10);

        for r_sample in (
          select sa.hsn, sa.original_coc, sa.collect_date, sa.receive_date
          from samples sa
          inner join profiles p on p.reqnbr = sa.reqnbr
          inner join aux_data ad1 on ad1.aux_data_id= sa.hsn and ad1.aux_data_type = 'S' and ad1.aux_data_format = 'TMON' and ad1.aux_field = 1
          inner join aux_data ad2 on ad2.aux_data_id= sa.hsn and ad2.aux_data_type = 'S' and ad2.aux_data_format = 'TMON' and ad2.aux_field = 2
          inner join map_to_addrs mta on mta.cust_id = p.cust_id and nvl(mta.reqnbr,p.reqnbr) = p.reqnbr and substr(mta.flags,5,1) = 'T' and substr(mta.delivery_methods,3,1) = 'E'
          inner join addresses ad on ad.addr_Seq= mta.addr_seq
          inner join aux_data ad3 on ad3.aux_data_id = ad.addr_seq and ad3.aux_data_type = 'A' and ad3.aux_Data_format = 'COLD' and ad3.aux_field = 1
          inner join aux_data ad4 on ad4.aux_data_id = ad.addr_seq and ad4.aux_data_type = 'A' and ad4.aux_Data_format = 'COLD' and ad4.aux_field = 2
          where ad1.aux_data = r_logger.tmon_make 
          and exists (Select 1 from schedules where proc_code = 'RCPTREPORT' and active_flag = 'A' and schedule_id = sa.hsn and schedule_type = 'S')
          and ad2.aux_data = r_logger.tmon_serial
          and trunc(sa.receive_date) = r_logger.RCPT_DATE
          UNION
          select sa.hsn, sa.original_coc, sa.collect_date, sa.receive_date
          from samples sa
          inner join profiles p on p.reqnbr = sa.reqnbr
          inner join aux_data ad1 on ad1.aux_data_id= sa.hsn and ad1.aux_data_type = 'S' and ad1.aux_data_format = 'TMON' and ad1.aux_field = 1
          inner join aux_data ad2 on ad2.aux_data_id= sa.hsn and ad2.aux_data_type = 'S' and ad2.aux_data_format = 'TMON' and ad2.aux_field = 2
          inner join map_to_addrs mta on mta.cust_id = p.cust_id and nvl(mta.reqnbr,p.reqnbr) = p.reqnbr and substr(mta.flags,5,1) = 'T' and substr(mta.delivery_methods,6,1) = 'W'
          inner join addresses ad on ad.addr_Seq= mta.addr_seq
          inner join aux_data ad3 on ad3.aux_data_id = ad.addr_seq and ad3.aux_data_type = 'A' and ad3.aux_Data_format = 'COLD' and ad3.aux_field = 1
          inner join aux_data ad4 on ad4.aux_data_id = ad.addr_seq and ad4.aux_data_type = 'A' and ad4.aux_Data_format = 'COLD' and ad4.aux_field = 2
          where ad1.aux_data = r_logger.tmon_make 
          and trunc(sa.receive_date) = r_logger.RCPT_DATE
          and ad2.aux_data = r_logger.tmon_serial
          ) loop
          
          v_error_email := v_error_email || r_sample.hsn || chr(10);

        end loop;

--        email_admin('Temp Logger file not found: '||v_filename,v_error_email);
        Err.EndHeader(v_Diag_Rec);
    end if;          
  end loop;

EXCEPTION
WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error then
  raise_application_error(-20000, 'Unable to send mail: '||sqlerrm);
END;