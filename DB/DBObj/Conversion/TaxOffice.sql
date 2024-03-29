use iTRAAC
go

/*************** tblTaxOffices */
ALTER TABLE tblTaxOffices ADD LocationOnly BIT DEFAULT((0))

ALTER TABLE tblTaxOffices DROP CONSTRAINT UIX_tblTaxOffices
ALTER TABLE tblTaxOffices ALTER COLUMN OfficeCode VARCHAR(4) NOT null
ALTER TABLE tblTaxOffices ALTER COLUMN StandardNAFI VARCHAR(9) NULL
ALTER TABLE tblTaxOffices ALTER COLUMN AgencyLine1 VARCHAR(100) NULL
ALTER TABLE tblTaxOffices ADD DEFAULT(0) FOR ProhibTransFlags 


SET IDENTITY_INSERT tblTaxOffices ON 
IF NOT EXISTS(SELECT 1 FROM tblTaxOffices WHERE OfficeCode = 'CUST')
  INSERT tblTaxOffices (TaxOfficeID, TaxOfficeName, OfficeCode, Active, LocationOnly) VALUES(2, 'Customer', 'CUST', 1, 1)
IF NOT EXISTS(SELECT 1 FROM tblTaxOffices WHERE OfficeCode = 'LOST')
  INSERT tblTaxOffices (TaxOfficeID, TaxOfficeName, OfficeCode, Active, LocationOnly) VALUES(3, 'Lost', 'LOST', 1, 1)
SET IDENTITY_INSERT tblTaxOffices OFF

UPDATE tblTaxOffices SET LocationOnly = 0 where OfficeCode not in ('CUST', 'LOST')

--ALTER TABLE tblTaxOffices DROP CONSTRAINT IX_OfficeCode
CREATE UNIQUE NONCLUSTERED INDEX ix_OfficeCode ON tblTaxOffices (OfficeCode, TaxOfficeID)

ALTER TABLE tblTaxOffices ADD Phone VARCHAR(20)
ALTER TABLE tblTaxOffices ADD OfficeHours VARCHAR(100)
ALTER TABLE tblTaxOffices ADD POC_UserGUID UNIQUEIDENTIFIER

------ _ -------------------------------- _ ---------- _ ----- _ ----------------------------------- _ -----
--    / \      ____   _       _____      / \          / /     | |      _   _  _____           __    | |  
--   / ^ \    / __ \ | |     |  __ \    / ^ \        / /      | |     | \ | ||  ___|\        / /    | |  
--  /_/ \_\  | |  | || |     | |  | |  /_/ \_\      / /     __| |__   |  \| || |__ \ \  /\  / /   __| |__
--    | |    | |  | || |     | |  | |    | |       / /      \ \ / /   |     ||  __| \ \/  \/ /    \ \ / /
--    | |    | |__| || |____ | |__| |    | |      / /        \ V /    | |\  || |____ \  /\  /      \ V / 
--    |_|     \____/ |______||_____/     |_|     /_/          \_/     |_| \_||______| \/  \/        \_/  
------------------------------------------------------------------------------------------------------------

