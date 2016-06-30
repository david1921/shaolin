module('MerchantPortal.Registration');

test('init', function(){
    var registration = MerchantPortal.Registration($);
    var mock = sinon.mock(registration);
    mock.expects('setupOnReady');
    mock.expects('setupCompaniesHouseClick');
    registration.init();
    ok(mock.verify());
});

// Add more unit tests for more MerchantPortal.Registration functions here
