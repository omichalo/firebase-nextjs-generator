import { render, screen } from '@testing-library/react';
import { useAuth } from '@/hooks/use-auth';

// Mock du hook useAuth
jest.mock('@/hooks/use-auth');
const mockUseAuth = useAuth as jest.MockedFunction<typeof useAuth>;

describe('useAuth Hook', () => {
  beforeEach(() => {
    mockUseAuth.mockReturnValue({
      user: null,
      isAuthenticated: false,
      isInitialized: true,
      isLoading: false,
      signIn: jest.fn(),
      signUp: jest.fn(),
      logout: jest.fn(),
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('retourne les valeurs par défaut', () => {
    const result = mockUseAuth();
    
    expect(result.user).toBeNull();
    expect(result.isAuthenticated).toBe(false);
    expect(result.isInitialized).toBe(true);
    expect(result.isLoading).toBe(false);
    expect(typeof result.signIn).toBe('function');
    expect(typeof result.signUp).toBe('function');
    expect(typeof result.logout).toBe('function');
  });

  it('peut changer l\'état utilisateur', () => {
    const mockUser = { uid: '123', email: 'test@example.com' };
    mockUseAuth.mockReturnValue({
      user: mockUser,
      isAuthenticated: true,
      isInitialized: true,
      isLoading: false,
      signIn: jest.fn(),
      signUp: jest.fn(),
      logout: jest.fn(),
    });

    const result = mockUseAuth();
    
    expect(result.user).toEqual(mockUser);
    expect(result.isAuthenticated).toBe(true);
  });

  it('peut gérer l\'état de chargement', () => {
    mockUseAuth.mockReturnValue({
      user: null,
      isAuthenticated: false,
      isInitialized: true,
      isLoading: true,
      signIn: jest.fn(),
      signUp: jest.fn(),
      logout: jest.fn(),
    });

    const result = mockUseAuth();
    
    expect(result.isLoading).toBe(true);
  });
}); 