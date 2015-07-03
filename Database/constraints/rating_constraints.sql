DELIMITER $$
CREATE TRIGGER rating_constraints BEFORE INSERT ON Rating FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);

    -- Gets a Table with all the Meals from the customer and checks if the one which is needed for the rating is presente
    SELECT COUNT( * ) INTO @o_existent
    FROM (

        SELECT dmm.Meal_meal_id_pk
        FROM Delivery_Meal_Map dmm
        INNER JOIN (

            SELECT * 
            FROM Delivery_View
            WHERE Customer_customer_id = NEW.Customer_customer_id_pk && delivery_status_type_number = 4
        )d ON d.delivery_id_pk = dmm.Delivery_delivery_id_pk
    )ddmm
    WHERE ddmm.Meal_meal_id_pk = NEW.Meal_meal_id_pk;

    IF !(NEW.rating >= 0 &&
        NEW.rating <= 5 &&
        @o_existent >= 1)
    THEN
        SET msg = "DIE: You inserted a resctricted VALUE";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;
$$
DELIMITER ;
