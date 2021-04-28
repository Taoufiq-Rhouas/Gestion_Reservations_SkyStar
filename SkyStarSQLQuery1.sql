CREATE DATABASE SkyStar;
use SkyStar;

/* CREATION TABLE CLIENTS */
CREATE TABLE CLIENTS (
	numPass varchar(255) PRIMARY KEY,
	nom varchar(255) NOT NULL UNIQUE,
	ville varchar(255)
);

/* CREATION TABLE CHAMBRES */
CREATE TABLE CHAMBRES(
	numC int PRIMARY KEY,
	lits int DEFAULT 2,
	prix float NOT NULL,
);

/* CREATION TABLE RESERVATIONS */
CREATE TABLE RESERVATIONS (
	numR varchar(255) PRIMARY KEY,
	numPass varchar(255) FOREIGN KEY REFERENCES CLIENTS(numPass),
	numC int FOREIGN KEY REFERENCES CHAMBRES(numC),
	arriv�e datetime default CURRENT_TIMESTAMP, 
	d�part DATE,
);


/* INSERTION SUR TABLE CLIENTS */
insert into CLIENTS (numPass, nom, ville) values ('numPass1','toto','Safi');
insert into CLIENTS (numPass, nom, ville) values ('numPass2','said','eljadida');
insert into CLIENTS (numPass, nom, ville) values ('numPass3','ahmed','casa');
insert into CLIENTS (numPass, nom, ville) values ('numPass4','yassine','taza');
insert into CLIENTS (numPass, nom, ville) values ('numPass5','salah','oualidia');

insert into CLIENTS (numPass, nom, ville) values ('numPassdrop1','zouhair','dakhla');
insert into CLIENTS (numPass, nom, ville) values ('numPassdrop2','karim','zaouia');


/* INSERTION SUR TABLE CHAMBRES */
insert into CHAMBRES (numC, lits, prix) values (1,1,100.50);
insert into CHAMBRES (numC, lits, prix) values (2,2,200.60);
insert into CHAMBRES (numC, lits, prix) values (3,3,300.80);
insert into CHAMBRES (numC, lits, prix) values (4,4,700);
insert into CHAMBRES (numC, lits, prix) values (5,5,800.80);



/* INSERTION SUR TABLE RESERVATIONS */
insert into RESERVATIONS (numR, numPass, numC,d�part) values ('numR','numPass1',1,'2004-01-22');
insert into RESERVATIONS (numR, numPass, numC,d�part) values ('numR2','numPass2',2,'2021-08-14');
insert into RESERVATIONS (numR, numPass, numC,d�part) values ('numR3','numPass3',3,'2021-08-12');
insert into RESERVATIONS (numR, numPass, numC,d�part) values ('numR4','numPass4',4,'2021-09-16');
insert into RESERVATIONS (numR, numPass, numC,d�part) values ('numR5','numPass5',5,'2021-08-18');

insert into RESERVATIONS (numR, numPass, numC,d�part) values ('numR6','numPass1',4,'2004-01-22');
insert into RESERVATIONS (numR, numPass, numC,d�part) values ('numR7','numPass1',5,'2004-08-22');

/*--------------------------------------------------------------*/
/* Function :1 */
/* affiche les chambres r�serv�es pendant le mois d'Ao�t dernier */

create function chambresReservesPendantMois(@mois date)
returns table
	as
		return
			SELECT * FROM RESERVATIONS WHERE RESERVATIONS.d�part >= @mois;


/* appel function 1 */
select * from [dbo].chambresReservesPendantMois('2021-08-01')

/*--------------------------------------------------------------*/

/* Function :2 */
/* affiche les client qui ont reserv� les chambres quit co�tent plus de 700 dhs */


create function clientReserveChambres(@prix float)
returns table
as
return
SELECT cl.* FROM CLIENTS cl,CHAMBRES ch,RESERVATIONS rs WHERE cl.numPass = rs.numPass and rs.numC = ch.numC and ch.prix >= @prix


/* appel function 2 */
select * from [dbo].clientReserveChambres(700)

/*--------------------------------------------------------------*/
/* Function :3 */
/* affiche les chambres reserv�es par les clients dont les noms commecent par A */


create function chambresReserveesByClient (@noms varchar(255))
returns table
as
return
SELECT ch.* FROM CLIENTS cl,CHAMBRES ch,RESERVATIONS rs WHERE cl.numPass = rs.numPass and rs.numC = ch.numC and nom LIKE ''+@noms+'%'

/* appel function 3 */
select * from [dbo].chambresReserveesByClient('A');

/*--------------------------------------------------------------*/
/* Function 4 */
/* affiche les clients qui ont r�serv�s plus de 2 chambres */


create function clientsReservesPlus2Chambres()
returns table
as
return
	select * from CLIENTS 
	where ( 
		select COUNT(numPass) 
		from RESERVATIONS 
		where numPass = CLIENTS.numPass 
		having count (RESERVATIONS.numC)>=2
	) != 0

select * from [dbo].clientsReservesPlus2Chambres();
/*--------------------------------------------------------------*/
/* Function 5 */
/* ffiche les clients qui habitent � Casablanca et qui on pass� plus de 2 r�servations ont r�serv�s plus de 2 chambres */

create function clientsReservesPlus2ChambresPlus2Reservations(@vill varchar(100))
returns table
as
return
	select * from CLIENTS 
	where ( 
		select COUNT(numPass) 
		from RESERVATIONS 
		where numPass = CLIENTS.numPass 
		having count (RESERVATIONS.numC)>=2
	) > 2 and ville = @vill

select * from [dbo].clientsReservesPlus2ChambresPlus2Reservations('Casablanca');

/*--------------------------------------------------------------*/
/* procedur 6 */
/* modifer le prix des chambres qui des prix sup�rieurs � 700dhs par 1000dhs */

CREATE PROCEDURE updatePriceChambre
AS
update CHAMBRES set prix = 1000 where prix > 700
GO;

EXEC updatePriceChambre
/*--------------------------------------------------------------*/
/* procedur 7 */
/* supprimer les clients qui n'ont pass� des r�servations */

CREATE PROCEDURE deletClientNotPassReservation
AS
delete from CLIENTS where numPass NOT IN (select numPass from RESERVATIONS)
GO;

EXEC deletClientNotPassReservation

/*--------------------------------------------------------------*/
/* procedur 8 */
/* ajouter 100dhs pour les chambres qui ont plus de 2 lits */

select * from CHAMBRES

CREATE PROCEDURE updatePrixPlusde2Lits
AS
update CHAMBRES set prix=prix+100 where lits>2
GO;

EXEC updatePrixPlusde2Lits











