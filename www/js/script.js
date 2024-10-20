function addPulsingMarker(map, lat, lng, options) {
    var pulsingIcon = L.circleMarker([lat, lng], {
      radius: options.radius,
      fillColor: options.fillColor,
      color: options.borderColor,
      fillOpacity: options.fillOpacity,
      className: 'pulse-marker'
    }).addTo(map);
  
    return pulsingIcon;
  }

  Shiny.addCustomMessageHandler('addPulsingMarker', function(message) {
    addPulsingMarker(window.myMap, message.lat, message.lng, message.options);
  });
  