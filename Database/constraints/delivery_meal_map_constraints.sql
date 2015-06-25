-- Constraints Delivery_Meal_Map
DELIMITER $$
CREATE TRIGGER delivery_meal_map_constraints BEFORE INSERT ON Delivery_Meal_Map FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    IF !(NEW.amount > 0) THEN
        SET msg = "DIE: You inserted a resctricted VALUE";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;
$$
DELIMITER ;
