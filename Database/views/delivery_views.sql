-- joins the Delivery_State with Delivery_State_Type together

CREATE VIEW Delivery_State_View AS 
SELECT Delivery_delivery_id_pk, date_pk, name as delivery_status_type, comment
FROM Delivery_State ds
INNER JOIN Delivery_State_Type dst ON ds.Delivery_State_Type_delivery_status_type = dst.delivery_status_type_id_pk;

-- joins the Delivery with Delivery_State together

CREATE VIEW Delivery_View AS 
SELECT d . * , ds.date_pk, Delivery_State_Type_delivery_status_type AS delivery_status_type_number, name AS delivery_status_type, ds.comment AS delivery_state_comment
FROM Delivery_State ds
INNER JOIN Delivery_State_Type dst ON ds.Delivery_State_Type_delivery_status_type = dst.delivery_status_type_id_pk
INNER JOIN Delivery d ON d.delivery_id_pk = ds.Delivery_delivery_id_pk;
