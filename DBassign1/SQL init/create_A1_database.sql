-- Create database
CREATE DATABASE [A1_database];
GO

-- Use the created database
USE [A1_database];
GO

BEGIN TRY
    BEGIN TRANSACTION CreateTablesTransaction;

		-- Create Regions table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Regions')
		BEGIN
		CREATE TABLE Regions (
			region_id INT PRIMARY KEY IDENTITY(1,1),
            region_name VARCHAR(255)
		);
		END

		-- Create CdpRegions table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CdpRegions')
		BEGIN
		CREATE TABLE CdpRegions (
            cdp_region_id INT PRIMARY KEY IDENTITY(1,1),
            cdp_region_name VARCHAR(255)
		);
		END

		-- Create Countries table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Countries')
		BEGIN
		CREATE TABLE Countries (
			country_id INT PRIMARY KEY IDENTITY(1,1),
			country_name VARCHAR(255),
			country_location VARCHAR(255),
			region_id INT NULL,
			cdp_region_id INT NULL,
			FOREIGN KEY (region_id) REFERENCES Regions(region_id),
			FOREIGN KEY (cdp_region_id) REFERENCES CdpRegions(cdp_region_id)
		);
		END

		-- Create Cities table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Cities')
		BEGIN
		CREATE TABLE Cities (
			city_id INT PRIMARY KEY,
			city_name VARCHAR(255),
			city_location VARCHAR(255),
			average_altitude VARCHAR(255),
			average_temp VARCHAR(255),
			country_id INT,
			FOREIGN KEY (country_id) REFERENCES Countries(country_id)
		);
		END

		-- Create City_GDPs table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'City_GDPs')
		BEGIN
		CREATE TABLE City_GDPs (
			gdp_id INT PRIMARY KEY,
			gdp INT,
			gdp_currency VARCHAR(255),
			gdp_source VARCHAR(255),
			gdp_year INT,
			city_id INT,
			FOREIGN KEY (city_id) REFERENCES Cities(city_id)
		);
		END

		-- Create City_Populations table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'City_Populations')
		BEGIN
		CREATE TABLE City_Populations (
			population_id INT PRIMARY KEY,
			population_amount INT,
			population_year INT,
			city_id INT,
			FOREIGN KEY (city_id) REFERENCES Cities(city_id)
		);
		END

		-- Create Organizations table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Organizations')
		BEGIN
		CREATE TABLE Organizations (
			organization_id INT PRIMARY KEY,
			organization_name VARCHAR(255) NOT NULL,
			accounting_year VARCHAR(255),
			C40_member BIT,
			GCoM_member BIT,
			organization_boundary VARCHAR(255),
			city_id INT,
			FOREIGN KEY (city_id) REFERENCES Cities(city_id)
		);
		END

		-- Create Assessments table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Assessments')
		BEGIN
		CREATE TABLE Assessments (
			assessment_id INT PRIMARY KEY,
			assessment_boundary VARCHAR(255),
			assessment_link VARCHAR(255),
			link_confirmation VARCHAR(255),
			assessment_factors VARCHAR(255),
			assessment_authors VARCHAR(255),
			adaptation_plan VARCHAR(255),
			organization_id INT,
			FOREIGN KEY (organization_id) REFERENCES Organizations(organization_id)
		);
		END

		-- Create Emissions table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Emissions')
		BEGIN
		CREATE TABLE Emissions (
			emission_id INT PRIMARY KEY,
			intensity_unit INT,
			gases_included VARCHAR(255),
			organization_id INT,
			FOREIGN KEY (organization_id) REFERENCES Organizations(organization_id)
		);
		END

		-- Create Scopes table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Scopes')
		BEGIN
		CREATE TABLE Scopes (
			scopes_id INT PRIMARY KEY,
			scope_name VARCHAR(255)
		);
		END

		-- Create Scope_Emissions table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Scope_Emissions')
		BEGIN
		CREATE TABLE Scope_Emissions (
			scope_emission_id INT PRIMARY KEY,
			scope_emission INT,
			scopes_id INT,
			emission_id INT,
			FOREIGN KEY (emission_id) REFERENCES Emissions(emission_id),
			FOREIGN KEY (scopes_id) REFERENCES Scopes(scopes_id)
		);
		END

		-- Create Comments table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Comments')
		BEGIN
		CREATE TABLE Comments (
			comment_id INT PRIMARY KEY,
			comment VARCHAR(255),
			comment_year INT,
			emission_id INT,
			FOREIGN KEY (emission_id) REFERENCES Emissions(emission_id)
		);
		END

		-- Create Protocols table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Protocols')
		BEGIN
		CREATE TABLE Protocols (
			protocol_id INT PRIMARY KEY,
			protocol VARCHAR(255),
			protocol_column VARCHAR(255),
			emission_id INT,
			FOREIGN KEY (emission_id) REFERENCES Emissions(emission_id)
		);
		END
		-- Create Methodologies table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Methodologies')
		BEGIN
		CREATE TABLE Methodologies (
			methodology_id INT PRIMARY KEY,
			primary_methodology VARCHAR(255),
			details VARCHAR(255),
			emission_id INT,
			FOREIGN KEY (emission_id) REFERENCES Emissions(emission_id)
		);
		END

		-- Create Base_Emissions table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Base_Emissions')
		BEGIN
		CREATE TABLE Base_Emissions (
			base_emission_id INT PRIMARY KEY,
			reporting_year INT,
			sector VARCHAR(255),
			baseline_year VARCHAR(255),
			baseline_emissions VARCHAR(255),
			emission_id INT,
			FOREIGN KEY (emission_id) REFERENCES Emissions(emission_id)
		);
		END

		-- Create Target_Emissions table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Target_Emissions')
		BEGIN
		CREATE TABLE Target_Emissions (
			target_emission_id INT PRIMARY KEY,
			pct_reduction_target INT,
			target_year VARCHAR(255),
			baseline_year VARCHAR(255),
			estimated_business_as_usual INT,
			target_boundary VARCHAR(255),
			sector VARCHAR(255),
			emission_id INT,
			FOREIGN KEY (emission_id) REFERENCES Emissions(emission_id)
		);
		END

		-- Create Target_Types table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Target_Types')
		BEGIN
		CREATE TABLE Target_Types (
			type_of_target_id INT PRIMARY KEY,
			type_of_target VARCHAR(255) NOT NULL,
			target_emission_id INT,
			FOREIGN KEY (target_emission_id) REFERENCES Target_Emissions(target_emission_id)
		);
		END

    COMMIT TRANSACTION CreateTablesTransaction;
	

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION CreateTablesTransaction;
		ROLLBACK TRANSACTION InsertTransaction;

    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage =  ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;