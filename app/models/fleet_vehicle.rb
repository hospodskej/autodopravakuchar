class FleetVehicle < Data.define(:name, :detail)
  extend SiteContent.collection(:fleet)
end
