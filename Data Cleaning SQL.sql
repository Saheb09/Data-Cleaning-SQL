Select * from NashvilleData

--Modifying the date format

Alter table NashvilleData
add SaleDateNew date;

Update NashvilleData
set SaledateNew= Convert(Date,Saledate)

Select SaleDateNew
from NashvilleData

-- Dealing with null values in PropertyAddress

Select x.ParcelId,x.PropertyAddress,y.ParcelId,y.PropertyAddress,isnull(x.PropertyAddress,y.PropertyAddress)
from NashvilleData x
join NashvilleData y
on x.ParcelId=y.ParcelId
and x.UniqueId<>y.UniqueId
where x.PropertyAddress is null

Update x
set PropertyAddress=isnull(x.PropertyAddress,y.PropertyAddress)
from NashvilleData x
join NashvilleData y
on x.ParcelId=y.ParcelId
and x.UniqueId<>y.UniqueId
where x.PropertyAddress is null

-- PropertyAddress to Address-City-State format
Alter table NashvilleData
add SplitAddress nvarchar(250);

Update NashvilleData
set SplitAddress= substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) 


Alter table NashvilleData
add SplitCity varchar(50);

Update NashvilleData
set SplitCity = substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))


select * from NashvilleData



-- Owner Address to Address-City-State


Alter table NashvilleData
add OwnerAddressSplit nvarchar(250);

Update NashvilleData
set OwnerAddressSplit= Parsename(replace(OwnerAddress,',','.'),3)

Alter table NashvilleData
add OwnerCitySplit nvarchar(250);

Update NashvilleData
set OwnerCitySplit= Parsename(replace(OwnerAddress,',','.'),2)

Alter table NashvilleData
add OwnerStateSplit nvarchar(250);

Update NashvilleData
set OwnerStateSplit= Parsename(replace(OwnerAddress,',','.'),1)

-- Update SoldasVacant Y and N to Yes and No


Update NashvilleData
set SoldasVacant= case
	when SoldasVacant='Y' then 'Yes'
	when SoldasVacant='N' then 'No'
	else SoldasVacant
end

select distinct(SoldasVacant) from NashvilleData

-- Dealing with Duplicates
with CTE_Data as (
select *,
row_number() over(
partition by ParcelId,PropertyAddress,SalePrice,SaleDate,LegalReference
order by UniqueID
) row_num
from NashvilleData
)
Delete from CTE_Data
where row_num>1

-- Dropping unused columns

Alter table NashvilleData
Drop column OwnerAddress,TaxDistrict,PropertyAddress
Alter table NashvilleData
Drop column SaleDate

select * from NashvilleData
	
