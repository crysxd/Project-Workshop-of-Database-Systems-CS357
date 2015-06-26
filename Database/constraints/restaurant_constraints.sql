-- Constraints for restaurant

DELIMITER $$
CREATE TRIGGER restaurant_constraints BEFORE INSERT ON Restaurant FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    IF !(NEW.shipping_cost >= 0 &&
        NEW.min_order_value >= 0 &&
        NEW.max_delivery_range >= 0 &&
        NEW.position_lat >= 0 &&
        NEW.position_long >= 0)
    THEN
        SET msg = "DIE: You inserted a resctricted VALUE";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;
$$
DELIMITER ;
