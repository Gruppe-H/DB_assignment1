-- Create database
CREATE DATABASE [SPA1_database];
GO

-- Use the created database
USE [SPA1_database];
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
			city_id INT PRIMARY KEY IDENTITY(1,1),
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
			gdp_id INT PRIMARY KEY IDENTITY(1,1),
			gdp INT,
			gdp_currency VARCHAR(255),
			gdp_source VARCHAR(255),
			city_id INT,
			FOREIGN KEY (city_id) REFERENCES Cities(city_id)
		);
		END

		-- Create City_Populations table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'City_Populations')
		BEGIN
		CREATE TABLE City_Populations (
			population_id INT PRIMARY KEY IDENTITY(1,1),
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
			organization_id INT PRIMARY KEY IDENTITY(1,1),
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
			assessment_id INT PRIMARY KEY IDENTITY(1,1),
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
			emission_id INT PRIMARY KEY IDENTITY(1,1),
			intensity_unit INT,
			gasses_included VARCHAR(255),
			organization_id INT,
			FOREIGN KEY (organization_id) REFERENCES Organizations(organization_id)
		);
		END

		-- Create Scopes table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Scopes')
		BEGIN
		CREATE TABLE Scopes (
			scopes_id INT PRIMARY KEY IDENTITY(1,1),
			scope_details VARCHAR(255),
			emission_id INT,
			FOREIGN KEY (emission_id) REFERENCES Emissions(emission_id)
		);
		END

		-- Create Comments table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Comments')
		BEGIN
		CREATE TABLE Comments (
			comment_id INT PRIMARY KEY IDENTITY(1,1),
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
			protocol_id INT PRIMARY KEY IDENTITY(1,1),
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
			methodology_id INT PRIMARY KEY IDENTITY(1,1),
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
			base_emission_id INT PRIMARY KEY IDENTITY(1,1),
			reporting_year INT,
			sector VARCHAR(255),
			baseline_year INT,
			baseline_emissions VARCHAR(255),
			emission_id INT,
			FOREIGN KEY (emission_id) REFERENCES Emissions(emission_id)
		);
		END

		-- Create Target_Emissions table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Target_Emissions')
		BEGIN
		CREATE TABLE Target_Emissions (
			target_emission_id INT PRIMARY KEY IDENTITY(1,1),
			pct_reduction_target INT,
			target_year INT,
			baseline_year INT,
			estimated_business_as_usual INT,
			target_boundary VARCHAR(255),
			emission_id INT,
			FOREIGN KEY (emission_id) REFERENCES Emissions(emission_id)
		);
		END

		-- Create Target_Types table
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Target_Types')
		BEGIN
		CREATE TABLE Target_Types (
			type_of_target_id INT PRIMARY KEY IDENTITY(1,1),
			type_of_target VARCHAR(255) NOT NULL,
			target_emission_id INT,
			FOREIGN KEY (target_emission_id) REFERENCES Target_Emissions(target_emission_id)
		);
		END

    COMMIT TRANSACTION CreateTablesTransaction;
	BEGIN TRANSACTION InsertTransaction;

		INSERT INTO Regions (region_name) VALUES ('South and West Asia'),('South Asia and Oceania'),('North America'),('Latin America'),('Europe'),('East Asia'),('Africa');
		INSERT INTO CdpRegions (cdp_region_name)
VALUES 
    ('Latin America'),
    ('East Asia'),
    ('Europe'),
    ('United States of America'),
    ('Southeast Asia'),
    ('Oceania'),
    ('Africa'),
    ('South Asia'),
    ('Canada'),
    ('Middle East');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Albania', '(41.153332, 20.168331)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Argentina', '(-38.416097, -63.616672)', '4', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Australia', '(-25.274398, 133.775136)', '2', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Belgium', NULL, NULL, '3');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Bolivia', '(-16.290154, -63.588653)', '4', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Bosnia & Herzegovina', NULL, NULL, '3');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Brazil', '(-14.235004, -51.92528)', '4', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Bulgaria', '(42.697708, 23.321868)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Burundi', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Cameroon', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Canada', '(56.130366, -106.346771)', '3', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Chile', '(-35.675147, -71.542969)', '4', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('China', '(35.86166, 104.195397)', '6', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('China, Hong Kong Special Administrative Region', NULL, NULL, '2');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Colombia', '(4.5709, -74.2973)', '4', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Comoros', '(-11.6455, 43.3333)', '7', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Costa Rica', NULL, NULL, '1');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Croatia', NULL, NULL, '3');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Cuba', NULL, NULL, '1');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Czechia', NULL, NULL, '3');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Côte d''Ivoire', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Democratic Republic of Congo', '(-4.038333, 21.758664)', '7', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Democratic Republic of the Congo', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Denmark', '(56.26392, 9.501785)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('East Asia', NULL, NULL, '2');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Ecuador', '(-1.831239, -78.183406)', '4', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Estonia', '(58.5953, 25.0136)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Eswatini', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Ethiopia', '(9.145, 40.489673)', '7', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Finland', '(61.92411, 25.748151)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('France', '(46.227638, 2.213749)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Georgia', '(40.786168, -81.288192)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Germany', '(51.165691, 10.451526)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Ghana', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Gibraltar', '(36.140751, -5.353585)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Greece', '(39.074208, 21.824312)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Guatemala', NULL, NULL, '1');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Hong Kong', '(22.396428, 114.109497)', '6', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Iceland', '(64.963051, -19.020835)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('India', '(20.5937, 78.9629)', '1', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Indonesia', '(-6.121435, 106.774124)', '2', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Ireland', '(53.41291, -8.24389)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Israel', '(31.046051, 34.851612)', '1', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Italy', '(41.87194, 12.56738)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Japan', '(36.204824, 138.252924)', '6', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Jordan', '(30.585164, 36.238414)', '1', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Kenya', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Latvia', '(56.8796, 24.6032)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Lithuania', '(55.169438, 23.881275)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Madagascar', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Malawi', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Malaysia', '(4.210484, 101.975766)', '2', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Mexico', '(23.634501, -102.552784)', '4', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Monaco', '(43.738418, 7.424616)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Montenegro', '(42.708678, 19.37439)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Morocco', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Mozambique', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Namibia', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Netherlands', '(52.132633, 5.291266)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('New Zealand', '(-40.900557, 174.885971)', '2', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Nigeria', '(9.081999, 8.675277)', '7', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Norway', '(60.472024, 8.468946)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Peru', '(-9.19, -75.0152)', '4', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Philippines', '(12.879721, 121.774017)', '2', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Poland', '(51.919438, 19.145136)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Portugal', '(39.399872, -8.224454)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Republic of Korea', NULL, NULL, '2');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Romania', '(45.943161, 24.96676)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Russia', '(61.52401, 105.318756)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Senegal', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Sierra Leone', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Singapore', '(1.352083, 103.819836)', '2', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Slovenia', '(46.151241, 14.995463)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('South Africa', '(-30.559482, 22.937506)', '7', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('South Korea', '(35.907757, 127.766922)', '6', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Spain', '(40.463667, -3.74922)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('State of Palestine', '(31.9522, 35.2332)', '1', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Sweden', '(60.128161, 18.643501)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Switzerland', '(46.818188, 8.227512)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Taiwan', '(23.69781, 120.960515)', '6', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Thailand', '(15.870032, 100.992541)', '2', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Togo', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Turkey', '(38.963745, 35.243322)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('USA', '(37.09024, -95.712891)', '3', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Uganda', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('United Arab Emirates', NULL, NULL, '10');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('United Kingdom', '(55.378051, -3.435973)', '5', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('United Kingdom of Great Britain and Northern Ireland', NULL, NULL, '3');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('United Republic of Tanzania', NULL, NULL, '7');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('United States of America', NULL, NULL, '4');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Uruguay', NULL, NULL, '1');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Venezuela', '(6.42375, -66.58973)', '4', NULL);
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Viet Nam', NULL, NULL, '5');
INSERT INTO Countries (country_name, country_location, region_id, cdp_region_id) VALUES ('Vietnam', '(14.058324, 108.277199)', '2', NULL);

	COMMIT TRANSACTION;

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
