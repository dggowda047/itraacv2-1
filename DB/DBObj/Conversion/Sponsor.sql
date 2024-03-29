USE iTRAAC
go

/*************** tblSponsors */
-- was originally considering tracking changes to DutyLocation since that gets printed on the Form paper (via something like "ReplacementSponsorGUID")
   -- but that's going through a lot of trouble to maintain a field that probably doesn't matter that much so bailing on that concept
   -- (that would open a lot of column duplication for very little benefit)
   -- still going to run with tblClient.ReplacementClientGUID in order to track name changes since that seems to matter _enough_ from a paper trail standpoint

-- "Date Estimated Return Over Seas" ... basically your expected PCS back to CONUS date... 
-- we could/should use this to mail folks reminders to cleanup outstanding forms before it's last minute (added this to req's list)
ALTER TABLE tblSponsors ADD DEROS DATETIME NULL

-- local address, versus the APO address, making it a rule that the existing v1 AddressLine1/2 fields are specifically intended for APO info
ALTER TABLE tblSponsors ADD HomeStreet       varchar(50)
ALTER TABLE tblSponsors ADD HomeStreetNumber varchar(10)
ALTER TABLE tblSponsors ADD HomeCity         varchar(50)
ALTER TABLE tblSponsors ADD HomePostal       varchar(5)

-- **** let's scratch all this email stuff until we understand it better
-- for now we can just keep thinking of the sponsor client record's email as the initial top choice
                -- email conversion... pull client emails up to sponsor level
                --UPDATE s SET s.email1 = c.email
                --FROM tblSponsors s
                --JOIN tblClients c ON c.SponsorGUID = s.RowGUID AND c.StatusFlags & POWER(2,0) = POWER(2,0)

ALTER TABLE tblSponsors ADD CreateDate DATETIME NOT NULL DEFAULT(GETDATE())
-- ALTER TABLE tblSponsors ALTER COLUMN CreateDate DATETIME NOT NULL 
-- UPDATE tblSponsors SET CreateDate = 0 WHERE CreateDate IS NULL

-- break out a new HomePhoneCountry field that we can start cleaning up on.
-- everything with a null CountryCode just gets left in the old HomePhone field and displayed in that slot in the UI
-- if you look at the data, there's a bunch of "none" or "XXXX-XXX" and other crap in that column but it's probably not worth the trouble to clean up until we have nothing better left TODO
ALTER TABLE tblSponsors ADD HomePhoneCountry VARCHAR(4) -- http://countrycode.org/

-- replaces AgentID
ALTER TABLE tblSponsors ADD CreateUserGUID UNIQUEIDENTIFIER

-- we're changing to the explicit convention that AddressLine2 is the CMR/BOX stuff and AddrLine1 is specifically reserved for "Garrison" type info (*not*required*)
-- that way AddressLine2 is the go-to sure bet line when we need a mailing address
ALTER TABLE tblSponsors ALTER COLUMN AddressLine1 VARCHAR(100) NULL

ALTER TABLE tblSponsors ADD CONSTRAINT DF_tblSponsors_RowGUID DEFAULT (NEWSEQUENTIALID()) FOR ROWGUID

------ _ -------------------------------- _ ---------- _ ----- _ ----------------------------------- _ -----
--    / \      ____   _       _____      / \          / /     | |      _   _  _____           __    | |  
--   / ^ \    / __ \ | |     |  __ \    / ^ \        / /      | |     | \ | ||  ___|\        / /    | |  
--  /_/ \_\  | |  | || |     | |  | |  /_/ \_\      / /     __| |__   |  \| || |__ \ \  /\  / /   __| |__
--    | |    | |  | || |     | |  | |    | |       / /      \ \ / /   |     ||  __| \ \/  \/ /    \ \ / /
--    | |    | |__| || |____ | |__| |    | |      / /        \ V /    | |\  || |____ \  /\  /      \ V / 
--    |_|     \____/ |______||_____/     |_|     /_/          \_/     |_| \_||______| \/  \/        \_/  
------------------------------------------------------------------------------------------------------------

-- household level field required for customer's overall UTAP profile
ALTER TABLE tblSponsors ADD IsUTAPActive BIT not null DEFAULT(0)
