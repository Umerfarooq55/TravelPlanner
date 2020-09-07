class flightsdeta {
  String _TravelFrm = "";
  String _TravelTo = "";
  String _DepartureDateFrom = "";
  String _DepartureDateTo = "";
  String _ReturnDateFrom = "";
  String _DeturnDateTo = "";
  String _NumberOfNights = "";
  bool _isdirect = false;
  bool _isRoundTrip = true;
  String _Adults = "";
  String _Child = "";
  String _ID = "";
  String _Lng = "";
  String _lat = "";

  flightsdeta(
      this._TravelFrm,
      this._TravelTo,
      this._DepartureDateFrom,
      this._DepartureDateTo,
      this._ReturnDateFrom,
      this._DeturnDateTo,
      this._NumberOfNights,
      this._isdirect,
      this._isRoundTrip,
      this._Adults,
      this._Child,
      this._ID,
      this._Lng,
      this._lat,);

  String get Child => _Child;

  set Child(String value) {
    _Child = value;
  }

  String get Adults => _Adults;

  set Adults(String value) {
    _Adults = value;
  }

  bool get isRoundTrip => _isRoundTrip;

  set isRoundTrip(bool value) {
    _isRoundTrip = value;
  }

  bool get isdirect => _isdirect;

  set isdirect(bool value) {
    _isdirect = value;
  }

  String get lat => _lat;

  set lat(String value) {
    _lat = value;
  }

  String get Lng => _Lng;

  set Lng(String value) {
    _Lng = value;
  }

  String get ID => _ID;

  set ID(String value) {
    _ID = value;
  }

  String get NumberOfNights => _NumberOfNights;

  set NumberOfNights(String value) {
    _NumberOfNights = value;
  }

  String get DeturnDateTo => _DeturnDateTo;

  set DeturnDateTo(String value) {
    _DeturnDateTo = value;
  }

  String get ReturnDateFrom => _ReturnDateFrom;

  set ReturnDateFrom(String value) {
    _ReturnDateFrom = value;
  }

  String get DepartureDateTo => _DepartureDateTo;

  set DepartureDateTo(String value) {
    _DepartureDateTo = value;
  }

  String get DepartureDateFrom => _DepartureDateFrom;

  set DepartureDateFrom(String value) {
    _DepartureDateFrom = value;
  }

  String get TravelTo => _TravelTo;

  set TravelTo(String value) {
    _TravelTo = value;
  }

  String get TravelFrm => _TravelFrm;

  set TravelFrm(String value) {
    _TravelFrm = value;
  }
}
