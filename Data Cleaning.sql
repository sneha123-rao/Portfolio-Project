
SELECT UniqueID,PropertyAddress,ParcelID
FROM housing.housing
order by ParcelID;

## Standardizing date in the Sale Date column

SELECT *
FROM housing.housing;

UPDATE housing.housing
set SaleDate=date_format(str_to_date(SaleDate, '%d-%b-%y'),'%d-%m-%Y');

## Updating null values in property address column

SELECT ParcelID,PropertyAddress
FROM housing.housing
WHERE PropertyAddress ='';

UPDATE housing.housing
SET housing.PropertyAddress =NULL
WHERE housing.PropertyAddress ='NULL';

SELECT 
a.PropertyAddress,
a.ParcelId,
b.PropertyAddress,
b.ParcelId,
IFNULL(a.PropertyAddress,b.PropertyAddress)
FROM housing.housing as a
join housing.housing as b
on a.ParcelId=b.ParcelId
and a.UniqueId != b.UniqueId
where a.PropertyAddress IS NULL;

UPDATE housing.housing as a
join housing.housing as b
on a.ParcelId=b.ParcelId
and a.UniqueId != b.UniqueId
SET a.PropertyAddress=ifnull(a.PropertyAddress,b.PropertyAddress)
where a.PropertyAddress IS NULL;

## Seperating the porperty address by street,city and state

## INSTR OR LOCATE have the same funcationality

SELECT SUBSTRING(PropertyAddress,1,INSTR(PropertyAddress,',')-1) as Address,
SUBSTRING(PropertyAddress,LOCATE(',',PropertyAddress)+1) as City
FROM housing.housing;

ALTER TABLE housing.housing
ADD Address varchar(255),
ADD City varchar(255);

UPDATE housing.housing
set Address=SUBSTRING(PropertyAddress,1,INSTR(PropertyAddress,',')-1) ,
City=SUBSTRING(PropertyAddress,LOCATE(',',PropertyAddress)+1);

## Seperating OnwerAddress into various columns

SELECT substring(OwnerAddress,1,INSTR(OwnerAddress,',')-1),
substring(OwnerAddress,LOCATE(',',OwnerAddress)+1,locate(',',OwnerAddress)-4),
SUBSTRING(OwnerAddress,-2)
FROM housing.housing;

ALTER TABLE housing.housing
ADD StreetName varchar(255),
ADD City1 varchar(255),
ADD State varchar(255);

UPDATE housing.housing
SET StreetName=substring(OwnerAddress,1,INSTR(OwnerAddress,',')-1),
City1=substring(OwnerAddress,LOCATE(',',OwnerAddress)+1,locate(',',OwnerAddress)-4),
State=SUBSTRING(OwnerAddress,-2);


## Replacing Y and N in SoldAsVacant to Yes and No

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM housing.housing
GROUP BY SoldAsVacant;

SELECT SoldAsVacant,
(CASE WHEN SoldAsVacant='Y' THEN 'Yes'
      WHEN SoldAsVacant='N' THEN 'No'
      ELSE SoldAsVacant
END ) as SoldAsVacant
FROM housing.housing;

UPDATE housing.housing
SET SoldAsVacant=(CASE WHEN SoldAsVacant='Y' THEN 'Yes'
      WHEN SoldAsVacant='N' THEN 'No'
      ELSE SoldAsVacant
END) ;

## Remove Duplicates

SELECT distinct(ParcelId),count(ParcelId)
from housing.housing 
group by ParcelId
having count(ParcelId)>1;


SELECT 
a.UniqueId,
a.ParcelId,
a.PropertyAddress,
a.SaleDate,
a.OwnerAddress
from housing.housing as a
join housing.housing as b
on  a.ParcelId=b.ParcelId
where a.UniqueId !=b.UniqueId;


delete a
FROM housing.housing as a 
join housing.housing as b 
on a.parcelId=b.ParcelId and a.UniqueId!=b.UniqueId 
where a.UniqueId>b.UniqueId;


