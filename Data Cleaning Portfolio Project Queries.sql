/*

Cleaning Data in SQL Queries

*/


Select * 
From PortfolioProject..NashvilleHousing



-- Standardize Date Format



Select SaleDateConverted, CONVERT(date,SaleDate) 
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)


ALTER Table NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)




-- Populate Property Address data

Select * 
From PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing as a
JOIN PortfolioProject..NashvilleHousing as b 
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing as a
JOIN PortfolioProject..NashvilleHousing as b 
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null






-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress 
From PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

From PortfolioProject..NashvilleHousing


ALTER Table PortfolioProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER Table PortfolioProject..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


Select * 
From PortfolioProject..NashvilleHousing






Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From PortfolioProject.dbo.NashvilleHousing




ALTER Table PortfolioProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)



ALTER Table PortfolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)



ALTER Table PortfolioProject..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


Select * 
From PortfolioProject..NashvilleHousing








-- Change Y and N to Yes and No in "Sold as Vacant" field


Select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From PortfolioProject..NashvilleHousing



Update PortfolioProject..NashvilleHousing
Set SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
	   








-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) row_num

From PortfolioProject.dbo.NashvilleHousing
)
Select * 
From RowNumCTE
Where row_num > 1
--order by PropertyAddress


Select * 
From PortfolioProject.dbo.NashvilleHousing







-- Delete Unused Columns




Select * 
From PortfolioProject.dbo.NashvilleHousing


Alter Table PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


Alter Table PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate