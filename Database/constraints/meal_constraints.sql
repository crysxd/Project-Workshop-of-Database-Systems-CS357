-- Constraints for Meal
DELIMITER $$
CREATE TRIGGER meal_constraints BEFORE INSERT ON Meal FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    IF !(NEW.price >= 0 &&
        NEW.spiciness <= 3 &&
        NEW.spiciness >= 0)
    THEN
        SET msg = "DIE: You inserted a resctricted VALUE";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;
$$
DELIMITER ;
