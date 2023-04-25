ALTER FUNCTION "DBA"."Zwroc_Id_Pracownika"( IN Id_Klienta INT )
RETURNS INT
NOT DETERMINISTIC
BEGIN
	DECLARE ID_Pracownika INT;

    Select top 1 Pracownik.Id_PR into ID_Pracownika
    From Faktura inner join Pracownik on Faktura.Id_PR=Pracownik.Id_PR
                 inner join Klient on Klient.Id_KL=Faktura.Id_KL
    Where Klient.Id_KL=Id_Klienta
    Group By Pracownik.Id_PR 
    Order By count(Pracownik.Id_PR) desc;

	RETURN ID_Pracownika;
END