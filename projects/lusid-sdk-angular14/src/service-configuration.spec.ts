import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule } from '@angular/common/http/testing';

import { BASE_PATH, Configuration, PortfoliosService } from './public-api';

const BASE_PATH_PROVIDER = {
  provide: BASE_PATH,
  useValue: 'https://base-path.lusid.com/api',
};
const CONFIGURATION_PROVIDER = {
  provide: Configuration,
  useValue: new Configuration({
    basePath: 'https://from-configuration.lusid.com/api',
  }),
};

describe('Service configuration', () => {
  // Doesn't matter which service we get, they all have the same constructor arguments
  function getService(): PortfoliosService {
    return TestBed.get<PortfoliosService>(PortfoliosService);
  }

  function configureTestingModule(...additionalProviders: any[]) {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [PortfoliosService, ...additionalProviders],
    });
  }

  describe('When neither BASE_PATH nor Configuration are supplied', () => {
    beforeEach(() => configureTestingModule());

    it('should use https://www.lusid.com/api as "basePath"', () => {
      expect(getService().configuration.basePath).toBe(
        'https://www.lusid.com/api'
      );
    });
  });

  describe('When only BASE_PATH is supplied', () => {
    beforeEach(() => configureTestingModule(BASE_PATH_PROVIDER));

    it('should use the BASE_PATH value as "basePath"', () => {
      expect(getService().configuration.basePath).toBe(
        BASE_PATH_PROVIDER.useValue
      );
    });
  });

  describe('When only Configuration is supplied', () => {
    beforeEach(() => configureTestingModule(CONFIGURATION_PROVIDER));

    it('should use the Configuration.BasePath value as "basePath"', () => {
      expect(getService().configuration.basePath).toBe(
        CONFIGURATION_PROVIDER.useValue.basePath
      );
    });
  });

  describe('When both BASE_PATH and Configuration are supplied', () => {
    beforeEach(() =>
      configureTestingModule(BASE_PATH_PROVIDER, CONFIGURATION_PROVIDER)
    );

    it('should use the Configuration.BasePath value as "basePath"', () => {
      expect(getService().configuration.basePath).toBe(
        CONFIGURATION_PROVIDER.useValue.basePath
      );
    });
  });
});
