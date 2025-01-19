USE [AquariumAutomationApp]
GO

/****** Object:  StoredProcedure [dbo].[uspRegisterUser]    Script Date: 19-01-2025 10:01:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[uspRegisterUser] (
	@UserFirstName varchar(255),
	@UserLastname varchar(255),
	@UserEmail varchar(255),
	@UserPhoneNumber varchar(20),
	@UserTypeId bigint,
	@UserCreatedDate datetime,
	@PasswordHash varbinary(max),
	@PasswordSalt varbinary(max),
	@AccountCreatedDate datetime,
	@UserId int output,
	@AccountId int output
)
AS

BEGIN
    -- Begin Transaction to ensure atomicity
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Declare variable to store the new primary key
        ---DECLARE @UserId INT;

        -- Insert into Table1 and get the new primary key
        INSERT INTO [dbo].[UserMaster]
           ([UserFirstName]
           ,[UserLastName]
           ,[UserEmail]
           ,[UserPhoneNumber]
           ,[UserTypeId]
		   ,[IsActive]
           ,[CreatedDate])
     VALUES
           (
				@UserFirstName,
				@UserLastName,
				@UserEmail,
				@UserPhoneNumber,
				@UserTypeId,
                1,
				@UserCreatedDate
			)

        SET @UserId = SCOPE_IDENTITY();

        -- Insert into Table2 using the primary key from Table1
        INSERT INTO [dbo].[AccountMaster]
           (
			[UserId]
           ,[PasswordHash]
           ,[PasswordSalt]
           ,[IsActive]
           ,[CreatedDate]
		   )
		VALUES
           (
				@UserId,
				@PasswordHash,
				@PasswordSalt,
                1,
				@AccountCreatedDate
			)
			SET @AccountId = SCOPE_IDENTITY();
        -- Commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of error
        ROLLBACK TRANSACTION;
			SET @UserId = -1;
			SET @AccountId = -1;
        -- Rethrow the error for debugging/logging
        THROW;
    END CATCH
END;
GO

-- 2. GetUserByEmail()
/****** Object:  StoredProcedure [dbo].[uspGetUserByEmail]    Script Date: 19-01-2025 10:01:44 PM ******/

CREATE PROCEDURE [dbo].[uspGetUserByEmail] (@Email varchar(255))  
AS  
BEGIN    
    select 
		u.UserId, 
		a.AccountId, 
		u.UserFirstName, 
		u.UserLastName,
        u.UserEmail, 
		u.UserPhoneNumber, 
		u.UserTypeId, 
        u.CreatedDate, 
		a.PassWordHash, 
		a.PassWordSalt, 
		a.CreatedDate,
        a.IsActive 
	from 
	UserMaster as u 
	inner join 
	AccountMaster a 
	on u.UserId = a.UserId 
	where u.UserEmail=@Email  
END 
GO

--- 3. Create new Aquarium



use AquariumAutomationApp
go

create procedure dbo.CreateAquarium
(
	@AquariumName varchar(255),
	@AquariumDescription varchar(255),
	@UserId bigint,
	@IsActive bit,
	@AquariumComments varchar(255),
	@AquariumCreatedDate datetime,
	@AquariumFixedPropertyComments varchar(255),
	@Length int,
	@Height int,
	@Width int,
	@AquariumFixedPropertyCreatedDate datetime,
	@AquariumId bigint output,
	@AquariumFixedPropertyId bigint output
)
as

begin

	--begin transaction to ensure atomicity
	begin transaction;
	begin try
	--insert into dbo.AquariumMaster
		insert into dbo.AquariumMaster 
		(
			[AquariumName],
			[AquariumDescription],
			[UserId],
			[IsActive],
			[Comments],
			[CreatedDate]
		)
		values
		(
			@AquariumName,
			@AquariumDescription,
			@UserId,
			@IsActive,
			@AquariumComments,
			@AquariumCreatedDate
		)
		set @AquariumId = SCOPE_IDENTITY();

		--insert into fixed properties table
		insert into dbo.AquariumFixedProperty
		(
			[AquariumId],
			[Comments],
			[Length],
			[Height],
			[Width],
			[CreatedDate]
		)
		values
		(
			@AquariumId,
			@AquariumFixedPropertyComments,
			@Length,
			@Height,
			@Width,
			@AquariumFixedPropertyCreatedDate
		)
		set @AquariumFixedPropertyId = SCOPE_IDENTITY();
	
		-- commit the transaction
		commit transaction;
	end try
	begin catch
		--rollback transaction in case of error
		rollback transaction;
		set @AquariumId = -1;
		set @AquariumFixedPropertyId = -1;
		--rethrow error for debug/log
		throw;
	end catch
end;
go