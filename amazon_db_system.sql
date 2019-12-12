-- =============================================
-- Authors: Ashwani K Kashyap, Anshul Pardhi, Gunjan Agicha
-- Create date: 11/27/2019
-- Description: Amazon database design, consisting of required tables, constraints, procedures and triggers
-- =============================================

CREATE TABLE amz_user (
    email       VARCHAR(255) PRIMARY KEY,
    fname       VARCHAR(255) NOT NULL,
    lname       VARCHAR(255),
    password    VARCHAR(30) NOT NULL,
    user_type   NUMBER(1) NOT NULL
);

CREATE TABLE contact_detail (
    user_id      VARCHAR(255) NOT NULL,
    address_id   INTEGER PRIMARY KEY,
    street1      VARCHAR(255) NOT NULL,
    street2      VARCHAR(255),
    city         VARCHAR(50) NOT NULL,
    state        VARCHAR(50) NOT NULL,
    country      VARCHAR(50) NOT NULL,
    zipcode      NUMBER(5) NOT NULL,
    phone        VARCHAR(20) NOT NULL,
    is_default   NUMBER(1) DEFAULT 0
);

CREATE TABLE card_info (
    card_id       INTEGER PRIMARY KEY,
    card_number   NUMBER(16) NOT NULL,
    expiry_date   DATE NOT NULL,
    cvv           NUMBER(3) NOT NULL,
    buyer_id      VARCHAR(255) NOT NULL,
    is_default    NUMBER(1)
);

CREATE TABLE buyer (
    buyer_id            VARCHAR(255) PRIMARY KEY,
    is_prime            NUMBER(1) DEFAULT 0,
    prime_expiry_date   DATE
);

CREATE TABLE seller (
    seller_id        VARCHAR(255) PRIMARY KEY,
    company_name     VARCHAR(255) NOT NULL,
    url              VARCHAR(255),
    description      VARCHAR(255),
    average_rating   NUMBER(2, 1) DEFAULT 2.5,
    rating_count     NUMBER DEFAULT 0
);

CREATE TABLE category (
    category_id     INTEGER PRIMARY KEY,
    category_name   VARCHAR(255) NOT NULL
);

CREATE TABLE product (
    product_id         INTEGER PRIMARY KEY,
    name               VARCHAR(255) NOT NULL,
    seller_id          VARCHAR(255) NOT NULL,
    price              NUMBER(10, 2) NOT NULL,
    rating             NUMBER(2, 1),
    review_count       INTEGER,
    category_id        INTEGER,
    description        VARCHAR(255),
    discount_percent   NUMBER(4, 2),
    available_units    INTEGER,
    color              VARCHAR(30),
    in_stock           NUMBER(1),
    weight             NUMBER(10, 2),
    carrier_id         INTEGER
);

CREATE TABLE product_image (
    product_id   INTEGER,
    image_url    VARCHAR(255),
    PRIMARY KEY ( product_id,
                  image_url )
);

CREATE TABLE shopping_cart (
    buyer_id     VARCHAR(255),
    date_added   DATE
);

CREATE TABLE product_shoppingcart (
    product_id   INTEGER,
    buyer_id     VARCHAR(255),
    PRIMARY KEY ( product_id,
                  buyer_id )
);

CREATE TABLE wish_list (
    buyer_id     VARCHAR(255),
    date_added   DATE
);

CREATE TABLE product_wishlist (
    product_id   INTEGER,
    buyer_id     VARCHAR(255),
    PRIMARY KEY ( product_id,
                  buyer_id )
);

CREATE TABLE amz_order (
    order_id              INTEGER PRIMARY KEY,
    buyer_id              VARCHAR(255) NOT NULL,
    card_id               INTEGER NOT NULL,
    total_price           NUMBER(10, 2),
    order_date            DATE,
    tax                   NUMBER(4, 2) DEFAULT 10,
    shipping_price        NUMBER(4, 2) DEFAULT 10,
    delivery_address_id   INTEGER,
    delivery_date         DATE,
    order_status          CHAR(1) NOT NULL,
    quantity              INTEGER NOT NULL
);

CREATE TABLE order_product (
    order_id     INTEGER,
    product_id   INTEGER,
    PRIMARY KEY ( order_id,
                  product_id )
);

CREATE TABLE review (
    review_id     INTEGER PRIMARY KEY,
    product_id    INTEGER NOT NULL,
    buyer_id      VARCHAR(255) NOT NULL,
    review        VARCHAR(1000),
    rating        NUMBER(2, 1),
    review_date   DATE
);

CREATE TABLE review_image (
    review_id   INTEGER,
    image_url   VARCHAR(255),
    PRIMARY KEY ( review_id,
                  image_url )
);

CREATE TABLE carrier (
    carrier_id      INTEGER PRIMARY KEY,
    carrier_name    VARCHAR(255) NOT NULL,
    carrier_phone   NUMBER(10) NOT NULL,
    carrier_email   VARCHAR(255) NOT NULL
);

ALTER TABLE contact_detail
    ADD CONSTRAINT contact_detail_user_id_fk FOREIGN KEY ( user_id )
        REFERENCES amz_user ( email )
            ON DELETE CASCADE;

ALTER TABLE card_info
    ADD CONSTRAINT card_info_buyer_id_fk FOREIGN KEY ( buyer_id )
        REFERENCES buyer ( buyer_id )
            ON DELETE CASCADE;

ALTER TABLE product
    ADD CONSTRAINT product_seller_id_fk FOREIGN KEY ( seller_id )
        REFERENCES seller ( seller_id )
            ON DELETE CASCADE;

ALTER TABLE product
    ADD CONSTRAINT product_category_id_fk FOREIGN KEY ( category_id )
        REFERENCES category ( category_id )
            ON DELETE CASCADE;

ALTER TABLE product
    ADD CONSTRAINT product_carrier_id_fk FOREIGN KEY ( carrier_id )
        REFERENCES carrier ( carrier_id )
            ON DELETE CASCADE;

ALTER TABLE product_image
    ADD CONSTRAINT product_image_product_id_fk FOREIGN KEY ( product_id )
        REFERENCES product ( product_id )
            ON DELETE CASCADE;

ALTER TABLE shopping_cart
    ADD CONSTRAINT shopping_cart_buyer_id_fk FOREIGN KEY ( buyer_id )
        REFERENCES buyer ( buyer_id )
            ON DELETE CASCADE;

ALTER TABLE product_shoppingcart
    ADD CONSTRAINT product_sc_buyer_id_fk FOREIGN KEY ( buyer_id )
        REFERENCES buyer ( buyer_id )
            ON DELETE CASCADE;

ALTER TABLE product_shoppingcart
    ADD CONSTRAINT product_sc_product_id_fk FOREIGN KEY ( product_id )
        REFERENCES product ( product_id )
            ON DELETE CASCADE;

ALTER TABLE wish_list
    ADD CONSTRAINT wishlist_buyer_id_fk FOREIGN KEY ( buyer_id )
        REFERENCES buyer ( buyer_id )
            ON DELETE CASCADE;

ALTER TABLE product_wishlist
    ADD CONSTRAINT product_wishlist_product_id_fk FOREIGN KEY ( product_id )
        REFERENCES product ( product_id )
            ON DELETE CASCADE;

ALTER TABLE product_wishlist
    ADD CONSTRAINT product_wishlist_buyer_id_fk FOREIGN KEY ( buyer_id )
        REFERENCES buyer ( buyer_id )
            ON DELETE CASCADE;

ALTER TABLE amz_order
    ADD CONSTRAINT order_buyer_id_fk FOREIGN KEY ( buyer_id )
        REFERENCES buyer ( buyer_id )
            ON DELETE CASCADE;

ALTER TABLE amz_order
    ADD CONSTRAINT order_card_id_fk FOREIGN KEY ( card_id )
        REFERENCES card_info ( card_id )
            ON DELETE CASCADE;

ALTER TABLE amz_order
    ADD CONSTRAINT order_delivery_address_id_fk FOREIGN KEY ( delivery_address_id )
        REFERENCES contact_detail ( address_id )
            ON DELETE CASCADE;

ALTER TABLE order_product
    ADD CONSTRAINT order_product_order_id_fk FOREIGN KEY ( order_id )
        REFERENCES amz_order ( order_id )
            ON DELETE CASCADE;

ALTER TABLE order_product
    ADD CONSTRAINT order_product_product_id_fk FOREIGN KEY ( product_id )
        REFERENCES product ( product_id )
            ON DELETE CASCADE;

ALTER TABLE review
    ADD CONSTRAINT review_product_id_fk FOREIGN KEY ( product_id )
        REFERENCES product ( product_id )
            ON DELETE CASCADE;

ALTER TABLE review
    ADD CONSTRAINT review_buyer_id_fk FOREIGN KEY ( buyer_id )
        REFERENCES buyer ( buyer_id )
            ON DELETE CASCADE;

ALTER TABLE review_image
    ADD CONSTRAINT review_image_review_id_fk FOREIGN KEY ( review_id )
        REFERENCES review ( review_id )
            ON DELETE CASCADE;

CREATE OR REPLACE PROCEDURE register_buyer (
    email      IN   VARCHAR,
    fname      IN   VARCHAR,
    lname      IN   VARCHAR,
    password   IN   VARCHAR
) AS
BEGIN
    INSERT INTO amz_user VALUES (
        email,
        fname,
        lname,
        password,
        0
    );

    INSERT INTO buyer VALUES (
        email,
        0,
        NULL
    );

END register_buyer;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE register_seller (
    email             IN   VARCHAR,
    fname             IN   VARCHAR,
    lname             IN   VARCHAR,
    password          IN   VARCHAR,
    company_name      IN   VARCHAR,
    url               IN   VARCHAR,
    description_var   IN   VARCHAR
) AS
BEGIN
    INSERT INTO amz_user VALUES (
        email,
        fname,
        lname,
        password,
        1
    );

    INSERT INTO seller VALUES (
        email,
        company_name,
        url,
        description_var,
        2.5,
        0
    );

END register_seller;

---------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_contact_details (
    user_id      IN   VARCHAR,
    address_id   IN   INTEGER,
    street1      IN   VARCHAR,
    street2      IN   VARCHAR,
    city         IN   VARCHAR,
    state        IN   VARCHAR,
    country      IN   VARCHAR,
    zipcode      IN   NUMBER,
    phone        IN   VARCHAR
) AS
BEGIN
    INSERT INTO contact_detail VALUES (
        user_id,
        address_id,
        street1,
        street2,
        city,
        state,
        country,
        zipcode,
        phone,
        0
    );

END add_contact_details;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE set_default_contact_details (
    contact_id   IN   INTEGER,
    buyer_id     IN   VARCHAR
) AS
BEGIN
    UPDATE contact_detail
    SET
        is_default = 1
    WHERE
        user_id = buyer_id
        AND address_id = contact_id;

END set_default_contact_details;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_card_info (
    buyer_id      IN   VARCHAR,
    card_id       IN   INTEGER,
    card_number   IN   NUMBER,
    expiry_date   IN   DATE,
    cvv           IN   NUMBER
) AS
BEGIN
    INSERT INTO card_info VALUES (
        card_id,
        card_number,
        expiry_date,
        cvv,
        buyer_id,
        0
    );

END add_card_info;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE set_default_card_info (
    card_id_var    IN   INTEGER,
    buyer_id_var   IN   VARCHAR
) AS
BEGIN
    UPDATE card_info
    SET
        is_default = 1
    WHERE
        buyer_id = buyer_id_var
        AND card_id = card_id_var;

END set_default_card_info;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_product (
    product_id        IN   INTEGER,
    name              IN   VARCHAR,
    seller_id         IN   VARCHAR,
    price             IN   NUMBER,
    category_id       IN   INTEGER,
    description       IN   VARCHAR,
    available_units   IN   INTEGER,
    color             IN   VARCHAR,
    weight            IN   NUMBER,
    carrier_id        IN   INTEGER,
    image_url         IN   VARCHAR
) AS
BEGIN
    INSERT INTO product VALUES (
        product_id,
        name,
        seller_id,
        price,
        0,
        0,
        category_id,
        description,
        0,
        available_units,
        color,
        1,
        weight,
        carrier_id
    );

    INSERT INTO product_image VALUES (
        product_id,
        image_url
    );

END add_product;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_to_shopping_cart (
    buyer_id     IN   VARCHAR,
    product_id   IN   INTEGER
) AS
BEGIN
    INSERT INTO shopping_cart VALUES (
        buyer_id,
        sysdate
    );

    INSERT INTO product_shoppingcart VALUES (
        product_id,
        buyer_id
    );

END add_to_shopping_cart;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_to_wish_list (
    buyer_id     IN   VARCHAR,
    product_id   IN   INTEGER
) AS
BEGIN
    INSERT INTO wish_list VALUES (
        buyer_id,
        sysdate
    );

    INSERT INTO product_wishlist VALUES (
        product_id,
        buyer_id
    );

END add_to_wish_list;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE give_review (
    review_id    IN   NUMBER,
    product_id   IN   INTEGER,
    buyer_id     IN   VARCHAR,
    review       IN   VARCHAR,
    rating       IN   NUMBER,
    image_url    IN   VARCHAR
) AS
BEGIN
    INSERT INTO review VALUES (
        review_id,
        product_id,
        buyer_id,
        review,
        rating,
        sysdate
    );

    INSERT INTO review_image VALUES (
        review_id,
        image_url
    );

END give_review;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER update_product_rating AFTER
    INSERT ON review
    FOR EACH ROW
DECLARE
    new_rating         NUMBER(2, 1);
    review_count_old   INTEGER;
BEGIN
    SELECT
        review_count
    INTO review_count_old
    FROM
        product
    WHERE
        product_id = :new.product_id;

    new_rating := :new.rating;
    UPDATE product
    SET
        rating = ( ( rating * review_count_old ) + new_rating ) / ( review_count_old + 1 ),
        review_count = review_count_old + 1
    WHERE
        product_id = :new.product_id;

END;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER update_seller_rating AFTER
    INSERT OR UPDATE OF rating ON review
    FOR EACH ROW
DECLARE
    new_rating            NUMBER(2, 1);
    seller_id_to_update   VARCHAR(255);
BEGIN
    new_rating := :new.rating;
    SELECT
        seller_id
    INTO seller_id_to_update
    FROM
        product
    WHERE
        product_id = :new.product_id;

    UPDATE seller
    SET
        average_rating = ( ( average_rating * rating_count ) + new_rating ) / ( rating_count + 1 ),
        rating_count = rating_count + 1
    WHERE
        seller_id = seller_id_to_update;

END;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE update_membership (
    buyer_id_input IN VARCHAR
) AS
BEGIN
    UPDATE buyer
    SET
        is_prime = 1,
        prime_expiry_date = add_months(DATE '2019-11-28', 12)
    WHERE
        buyer_id = buyer_id_input;

END update_membership;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE cancel_membership (
    buyer_id_input IN VARCHAR
) AS
BEGIN
    UPDATE buyer
    SET
        is_prime = 0,
        prime_expiry_date = NULL
    WHERE
        buyer_id = buyer_id_input;

END cancel_membership;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE place_order (
    order_id       IN   INTEGER,
    buyer_id_var   IN   VARCHAR
) AS

    card_id_var           INTEGER;
    address_id_var        INTEGER;
    total_price_var       NUMBER := 0;
    curr_price_var        NUMBER;
    total_qty_var         NUMBER := 0;
    available_units_var   NUMBER(1);
    shipping_price_var    NUMBER := 10;
    is_prime_var          NUMBER := 0;
    CURSOR products_cur IS
    SELECT
        product_id
    FROM
        product_shoppingcart
    WHERE
        buyer_id = buyer_id_var;

    product_id_var        INTEGER;
BEGIN
    OPEN products_cur;
    LOOP
        FETCH products_cur INTO product_id_var;
        EXIT WHEN products_cur%notfound;
        SELECT
            price,
            available_units
        INTO
            curr_price_var,
            available_units_var
        FROM
            product
        WHERE
            product_id = product_id_var;

        IF available_units_var > 0 THEN
            total_price_var := ( total_price_var + curr_price_var );
            total_qty_var := total_qty_var + 1;
            INSERT INTO order_product VALUES (
                order_id,
                product_id_var
            );

        END IF;
        
--        DELETE FROM product_shoppingcart
--        WHERE product_id = product_id_var AND buyer_id = buyer_id_var;

    END LOOP;

    CLOSE products_cur;
    SELECT
        is_prime
    INTO is_prime_var
    FROM
        buyer
    WHERE
        buyer_id = buyer_id_var;

    IF is_prime_var = 1 THEN
        shipping_price_var := 0;
    END IF;
    SELECT
        card_id
    INTO card_id_var
    FROM
        card_info
    WHERE
        buyer_id = buyer_id_var
        AND is_default = 1;

    SELECT
        address_id
    INTO address_id_var
    FROM
        contact_detail
    WHERE
        user_id = buyer_id_var
        AND is_default = 1;

    total_price_var := total_price_var + shipping_price_var + 10;
    INSERT INTO amz_order VALUES (
        order_id,
        buyer_id_var,
        card_id_var,
        total_price_var,
        sysdate,
        10,
        shipping_price_var,
        address_id_var,
        add_months(DATE '2019-11-28', 1),
        'c',
        total_qty_var
    );

END place_order;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE populate_product_categories AS
BEGIN
    INSERT INTO category VALUES (
        1,
        'Electronics'
    );

    INSERT INTO category VALUES (
        2,
        'Books'
    );

    INSERT INTO category VALUES (
        3,
        'Clothing'
    );

END populate_product_categories;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE populate_carriers AS
BEGIN
    INSERT INTO carrier VALUES (
        1,
        'DHL',
        1234567890,
        'DHL@gmail.com'
    );

    INSERT INTO carrier VALUES (
        2,
        'Fedex',
        1234567890,
        'Fedex@gmail.com'
    );

    INSERT INTO carrier VALUES (
        3,
        'UPS',
        1234567890,
        'UPS@gmail.com'
    );

END populate_carriers;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER update_available_units AFTER
    INSERT ON amz_order
    FOR EACH ROW
DECLARE
    product_id_var        INTEGER;
    available_units_var   INTEGER;
    CURSOR products_cur IS
    SELECT
        product_id
    FROM
        order_product
    WHERE
        order_id = :new.order_id;

BEGIN
    OPEN products_cur;
    LOOP
        FETCH products_cur INTO product_id_var;
        EXIT WHEN products_cur%notfound;
        SELECT
            available_units
        INTO available_units_var
        FROM
            product
        WHERE
            product_id = product_id_var;

        IF available_units_var >= 2 THEN
            UPDATE product
            SET
                available_units = available_units - 1
            WHERE
                product_id = product_id_var;

        ELSIF available_units_var = 1 THEN
            UPDATE product
            SET
                available_units = available_units - 1,
                in_stock = 0
            WHERE
                product_id = product_id_var;

        END IF;

    END LOOP;

    CLOSE products_cur;
END;

CREATE OR REPLACE TRIGGER remove_items_from_cart AFTER
    INSERT ON amz_order
    FOR EACH ROW
DECLARE BEGIN
    DELETE FROM shopping_cart
    WHERE
        buyer_id = :new.buyer_id;

    DELETE FROM product_shoppingcart
    WHERE
        buyer_id = :new.buyer_id;

END;

BEGIN
    register_buyer('anshulpardhi@gmail.com', 'anshul', 'pardhi', 'abcd123');
    register_buyer('ashwanikashyap@gmail.com', 'ashwani', 'kashyap', 'abcd123');
    register_buyer('gunjanagicha@gmail.com', 'gunjan', 'agicha', 'abcd123');
END;

BEGIN
    register_seller('kushagradar@gmail.com', 'kushagra', 'dar', 'abcd123', 'kushagra Co and Co',
                    'www.kusharga.com', 'company of shoes');
    register_seller('ruchisingh@gmail.com', 'ruchi', 'singh', 'abcd123', 'ruchi Co and Co',
                    'www.ruchi.com', 'company of metals');
    register_seller('anantprakash@gmail.com', 'anant', 'prakash', 'abcd123', 'anant Co and Co',
                    'www.anant.com', 'company of iphones');
END;

BEGIN
    update_contact_details('anshulpardhi@gmail.com', 1, '7825 McCallum Blvd', 'Apt 007', 'Dallas',
                           'Texas', 'USA', 75252, 8888888888);

    update_contact_details('gunjanagicha@gmail.com', 2, '7825 McCallum Blvd', 'Apt 1702', 'Dallas',
                           'Texas', 'USA', 75252, 8888888888);

    update_contact_details('gunjanagicha@gmail.com', 3, '7825 McCallum Blvd', 'Apt 1702', 'Dallas',
                           'Texas', 'USA', 75252, 4692309274);

    set_default_contact_details(3, 'gunjanagicha@gmail.com');
    set_default_contact_details(1, 'anshulpardhi@gmail.com');
END;

BEGIN
    add_card_info('gunjanagicha@gmail.com', 1, 1234123412341234, TO_DATE('2023-12-09', 'YYYY-MM-DD'),
                  666);
    add_card_info('gunjanagicha@gmail.com', 2, 0234123412341234, TO_DATE('2023-12-09', 'YYYY-MM-DD'),
                  777);
    add_card_info('anshulpardhi@gmail.com', 3, 0234123412341234, TO_DATE('2023-12-09', 'YYYY-MM-DD'),
                  777);
    set_default_card_info(1, 'gunjanagicha@gmail.com');
    set_default_card_info(3, 'anshulpardhi@gmail.com');
END;

BEGIN
    populate_product_categories();
    populate_carriers();
END;

BEGIN
    add_product(1, 'OnePlus 7', 'kushagradar@gmail.com', 400, 1,
                'Best Phone', 2, 'Blue', 2, 2,
                'bit.ly/sfdf4fg');

    add_product(2, 'Harry Potter', 'kushagradar@gmail.com', 15, 2,
                'Best Book', 5, 'Black', 8, 2,
                'bit.ly/sfdf4fg');

    add_product(3, 'Nike Shoes', 'anantprakash@gmail.com', 50, 3,
                'Best shoes', 2, 'yellow', 5, 1,
                'bit.ly/sfdf4fg');

    add_product(4, 'I phone', 'anantprakash@gmail.com', 500, 1,
                'Better than android', 3, 'Black', 2, 3,
                'bit.ly/sfdf4fg');

    add_product(5, 'Metal Detector', 'ruchisingh@gmail.com', 20, 1,
                'Best metal detector', 4, 'Grey', 12, 2,
                'bit.ly/sfdf4fg');

END;

BEGIN
    add_to_wish_list('anshulpardhi@gmail.com', 1);
    add_to_wish_list('anshulpardhi@gmail.com', 4);
    add_to_wish_list('anshulpardhi@gmail.com', 3);
    add_to_wish_list('gunjanagicha@gmail.com', 2);
END;

BEGIN
    add_to_shopping_cart('anshulpardhi@gmail.com', 1);
    add_to_shopping_cart('anshulpardhi@gmail.com', 3);
    add_to_shopping_cart('gunjanagicha@gmail.com', 2);
    add_to_shopping_cart('gunjanagicha@gmail.com', 1);
END;

BEGIN
    update_membership('gunjanagicha@gmail.com');
END;

BEGIN
    place_order(1, 'gunjanagicha@gmail.com');
END;

BEGIN
    place_order(2, 'anshulpardhi@gmail.com');
END;

BEGIN
    give_review(1, 1, 'anshulpardhi@gmail.com', 'cool phone with great camera', 5,
                'www.my_image.com');
    give_review(2, 3, 'anshulpardhi@gmail.com', 'good running shoes', 3,
                'www.my_image.com');
END;

BEGIN
    give_review(3, 2, 'gunjanagicha@gmail.com', 'nice book', 3.5,
                'www.my_image.com');
END;

BEGIN
    give_review(4, 1, 'gunjanagicha@gmail.com', 'okay phone', 3,
                'www.my_image.com');
END;

BEGIN
    give_review(5, 5, 'gunjanagicha@gmail.com', 'doesnt work', 1,
                'www.my_image.com');
END;

BEGIN
    give_review(6, 5, 'gunjanagicha@gmail.com', 'doesnt work at all', 0,
                'www.my_image.com');
END;