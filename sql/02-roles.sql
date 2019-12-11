GRANT anon TO authenticator;
GRANT USAGE ON SCHEMA public TO anon;
GRANT EXECUTE ON FUNCTION declare_new_screen() TO anon;
GRANT INSERT ON screens TO anon;

GRANT bo_user TO authenticator;
GRANT USAGE ON SCHEMA public TO bo_user;
GRANT ALL ON ALL TABLES IN SCHEMA public TO bo_user;
