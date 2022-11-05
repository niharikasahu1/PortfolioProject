

select *
from PortfolioProject..NashvilleHousing

--Standardize Date format

select SaleDateConverted,CONVERT(Date,SaleDate) as Date
from PortfolioProject..NashvilleHousing

--Update NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE PortfolioProject..NashvilleHousing
add SaleDateConverted Date;

update PortfolioProject..NashvilleHousing
set SaleDateConverted = convert(Date,SaleDate)


--Populate Property Address data

select PropertyAddress
from PortfolioProject..NashvilleHousing

--Filter only Null values in Property address column
select *
from PortfolioProject..NashvilleHousing
where PropertyAddress is null

select *
from PortfolioProject..NashvilleHousing
order by  ParcelID


select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address into Individual Columns (Address,City,State)

select PropertyAddress
from PortfolioProject..NashvilleHousing


select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
--CHARINDEX(',',PropertyAddress)
from PortfolioProject..NashvilleHousing


select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
--CHARINDEX(',',PropertyAddress)
from PortfolioProject..NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
add PropertySplitAddress nvarchar(255);

Update PortfolioProject..NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table PortfolioProject..NashvilleHousing
add PropertySplitCity nvarchar(255);

update PortfolioProject..NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


select *
from PortfolioProject..NashvilleHousing

--Breaking out OwnerAddress into Individual Columns (Address,City,State)

select OwnerAddress
from PortfolioProject..NashvilleHousing

select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from PortfolioProject..NashvilleHousing


Alter table PortfolioProject..NashvilleHousing
add OwnderAddress nvarchar(255)

update PortfolioProject..NashvilleHousing
set OwnderAddress = PARSENAME(replace(OwnerAddress,',','.'),3)

Alter table PortfolioProject..NashvilleHousing
add OwnderAddressCity nvarchar(255)

update PortfolioProject..NashvilleHousing
set OwnderAddressCity = PARSENAME(replace(OwnerAddress,',','.'),2)

Alter table PortfolioProject..NashvilleHousing
add OwnderAddressState nvarchar(255)

update PortfolioProject..NashvilleHousing
set OwnderAddressState = PARSENAME(replace(OwnerAddress,',','.'),1)

select * 
from PortfolioProject..NashvilleHousing

-- Change Y and N to Yes and NO in 'Sold as Vacant' field

select distinct (SoldAsVacant)
from PortfolioProject..NashvilleHousing

select distinct (SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant, 
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from PortfolioProject..NashvilleHousing


update PortfolioProject..NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end


select * 
from PortfolioProject..NashvilleHousing

--Remove Duplicate

select *,
   ROW_NUMBER () over (
   partition by ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
				  UniqueID
				  ) row_num
from PortfolioProject..NashvilleHousing

order by ParcelID


with RownumCTE as(
select *,
   ROW_NUMBER () over (
   partition by ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
				  UniqueID
				  ) row_num
from PortfolioProject..NashvilleHousing)

select * 
from RownumCTE
where row_num > 1
order by PropertyAddress


with RownumCTE as(
select *,
   ROW_NUMBER () over (
   partition by ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
				  UniqueID
				  ) row_num
from PortfolioProject..NashvilleHousing)

delete 
from RownumCTE
where row_num > 1


with RownumCTE as(
select *,
   ROW_NUMBER () over (
   partition by ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
				  UniqueID
				  ) row_num
from PortfolioProject..NashvilleHousing)

select * 
from RownumCTE
where row_num > 1
order by PropertyAddress


--Delete Unused Columns'

select * 
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress



select * 
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column SaleDate

select * 
from PortfolioProject..NashvilleHousing