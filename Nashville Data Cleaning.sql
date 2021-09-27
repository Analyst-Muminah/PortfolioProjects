/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[ Nashville Housing]

  SELECT*
  FROM [PortfolioProject].[dbo].[ Nashville Housing]


  --Standardise Date Format

  SELECT SaleDateConverted, CONVERT(Date,SaleDate) 
  FROM [PortfolioProject].[dbo].[ Nashville Housing]

  ALTER TABLE [ Nashville Housing]
  Add SaleDateConverted Date;

  UPDATE [ Nashville Housing]
  SET SaleDateConverted = CONVERT(Date,SaleDate) 


   --Populating Property Address Data

   SELECT *
  FROM [PortfolioProject].[dbo].[ Nashville Housing]
  --ORDER BY ParcelID
  WHERE PropertyAddress is null

  SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  FROM [PortfolioProject].[dbo].[ Nashville Housing] a
  JOIN PortfolioProject.dbo.[ Nashville Housing] b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
 WHERE a.PropertyAddress is null

 UPDATE a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM [PortfolioProject].[dbo].[ Nashville Housing] a
  JOIN PortfolioProject.dbo.[ Nashville Housing] b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null

   --Breaking out Address into Individual Column(Address, city, state)

    SELECT PropertyAddress
  FROM [PortfolioProject].[dbo].[ Nashville Housing]
   
   SELECT
   SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) as Address
  , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

   FROM [PortfolioProject].[dbo].[ Nashville Housing]
   
   ALTER TABLE [ Nashville Housing]
  Add  PropertySplitAddress Nvarchar(255);

  UPDATE [ Nashville Housing]
  SET PropertySplitAddress  = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)  

   ALTER TABLE [ Nashville Housing]
  Add  PropertySplitCity Nvarchar(255);

  UPDATE [ Nashville Housing]
  SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) 


  -- OR

  SELECT *
  FROM [PortfolioProject].[dbo].[ Nashville Housing]

  SELECT OwnerAddress
  FROM [PortfolioProject].[dbo].[ Nashville Housing]

  SELECT
  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
  ,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
   ,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
   FROM [PortfolioProject].[dbo].[ Nashville Housing]

   ALTER TABLE [ Nashville Housing]
  Add   OwnerSplitAddress Nvarchar(255);

  UPDATE [ Nashville Housing]
  SET OwnerSplitAddress  =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

   ALTER TABLE [ Nashville Housing]
  Add  OwnerSplitCity Nvarchar(255);

  UPDATE [ Nashville Housing]
  SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

  ALTER TABLE [ Nashville Housing]
  Add  OwnerSplitState Nvarchar(255);

  UPDATE [ Nashville Housing]
  SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

  SELECT DISTINCT(SoldAsVacant)
  FROM [PortfolioProject].[dbo].[ Nashville Housing]

  --Changing Value

   SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
   FROM [PortfolioProject].[dbo].[ Nashville Housing]
   GROUP BY SoldAsVacant
   ORDER BY 2
   
   SELECT SoldAsVacant,
   CASE When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		ELSE SoldAsVacant
		END
  FROM [PortfolioProject].[dbo].[ Nashville Housing]

   UPDATE [ Nashville Housing]
  SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		ELSE SoldAsVacant
		END 

-- Removing Duplicate

WITH RowNumCTE as(
SELECT*,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				    UniqueID
					) row_num

FROM [PortfolioProject].[dbo].[ Nashville Housing]
 )
 SELECT*
 FROM RowNumCTE
 WHERE row_num > 1
 ORDER BY PropertyAddress
  
  --Deleting Unused Data

  SELECT *
  FROM [PortfolioProject].[dbo].[ Nashville Housing]

  ALTER TABLE [PortfolioProject].[dbo].[ Nashville Housing]
  DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddresss

  ALTER TABLE [PortfolioProject].[dbo].[ Nashville Housing]
  DROP COLUMN  SaleDate
