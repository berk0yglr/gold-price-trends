use [gold-price-trends]

select * from dbo.finalgolddata

--------------------------------
select
 MIN(Date) as eskiler,
 MAX(Date) as yeniler,
 COUNT(*) as toplam_satir
from dbo.finalgolddata 

--------------------------------
select 
	Date AS Tarih,
	[Open] as Acilis
from dbo.finalgolddata
where [Open] > 10000

--------------------------------
SELECT 
    Date AS Tarih,
    CASE WHEN [Open] > 10000 THEN [Open] / 10000000.0 ELSE [Open] END AS Cleaned_Open,
    CASE WHEN [High] > 10000 THEN [High] / 10000000.0 ELSE [High] END AS Cleaned_High,
    CASE WHEN [Low] > 10000 THEN [Low] / 10000000.0 ELSE [Low] END AS Cleaned_Low,
    CASE WHEN [Close] > 10000 THEN [Close] / 10000000.0 ELSE [Close] END AS Cleaned_Close,
    Volume
FROM dbo.finalgolddata;

--------------------------------
WITH TemizlenmisVeri AS (
    select 
        YEAR(Date) AS Yil,
        CASE WHEN [Close] > 10000 THEN [Close] / 10000000.0 ELSE [Close] END AS Cleaned_Close
    from dbo.finalgolddata
)
select 
    Yil,
    AVG(Cleaned_Close) AS Ortalama_Kapanis
from TemizlenmisVeri
group by Yil
order by Yil;
