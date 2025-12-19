{ ... }:
{
  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "app-db"
      "ferret"
    ];
    ensureUsers = [
      {
        name = "app-db";
        ensureDBOwnership = true;
      }
      {
        name = "ferret";
        ensureDBOwnership = true;
      }
    ];
    enableTCPIP = true;
  };

  services.ferretdb = {
    enable = true;
    settings = {
      FERRETDB_LISTEN_ADDR = "0.0.0.0:27017";
      FERRETDB_HANDLER = "pg";
      FERRETDB_POSTGRESQL_URL = "postgres://ferret@localhost/ferret";
    };
  };

  systemd.services.ferretdb = {
    after = [ "postgresql.target" ];
    bindsTo = [ "postgresql.target" ];
  };
}
