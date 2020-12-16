-- Run these commands as sys user logged in as sysdba on Goodman and always commit after running each statement.

-- This statement removes an ACE (12c remove ACE)
--   Check to see if it is removed with this query:
--   SELECT *
--     FROM dba_host_aces;
BEGIN
dbms_network_acl_admin.remove_host_ace(
  host => '192.168.103.25',
  lower_port => 9100,
  upper_port => 9100,
  ace  =>  xs$ace_type(privilege_list => xs$name_list('connect'),
                       principal_name => 'SMRTL_LIMS',
                       principal_type => xs_acl.ptype_db)); 
END;
/

-- This statement removes a device from ACL (11g remove ACL*)
--   The acl input must be the ACL of the device you want to remove.
--   Run this query to get it:
--   SELECT *
--     FROM dba_host_acls;
--   * Oracle states that they have deprecated this statement listed below.
BEGIN
   DBMS_NETWORK_ACL_ADMIN.DROP_ACL (
    acl          => 'NETWORK_ACL_7748E22F34F53349E0532866A8C08640');
   COMMIT;
END;
/


--  This statement appends a device's ACE to the ACE list (12c append ACE)
BEGIN
  DBMS_NETWORK_ACL_ADMIN.append_host_ace (
    host       => '192.168.102.191', 
    lower_port => 9100,
    upper_port => 9100,
    ace        => xs$ace_type(privilege_list => xs$name_list('connect'),
                              principal_name => 'SMRTL_LIMS',
                              principal_type => xs_acl.ptype_db)); 
END;
/

-- This statement appends a device to an ACL (12c append to ACL)
--    The acl input in this procedure can be any ACL for a device that already has an ACL
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACL (
    host       => '192.168.102.191',
    lower_port => 9100,
    upper_port => 9100,
    acl        => 'NETWORK_ACL_6D61DD1433140FF0E0532866A8C00184');
END;
/