{ ... }:
{
  services.postgresql = {
    authentication = ''
      host    all    all   127.0.0.1/0    trust
    '';
  };

  virtualisation.forwardPorts = [
    {
      host.port = 5432;
      guest.port = 5432;
    }
    {
      host.port = 27017;
      guest.port = 27017;
    }
  ];
}
