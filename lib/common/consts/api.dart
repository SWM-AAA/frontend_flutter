enum API {
  // user
  register,
  // map
  postLocationAndBattery,
}

Map<API, String> apiMap = {
  // user
  API.register: '/register',
  // map
  API.postLocationAndBattery: '/api/v1/users/location-and-battery',
};
