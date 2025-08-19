import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut,
  onAuthStateChanged,
  User,
} from 'firebase/auth';
import { auth } from '@/lib/firebase';
import { RootState } from '@/stores/store';
import { setUser, setLoading, setError } from '@/stores/auth-slice';

export const useAuth = () => {
  const dispatch = useDispatch();
  const authState = useSelector((state: RootState) => state.auth);
  const { user, isLoading, error } = authState;
  const [isInitialized, setIsInitialized] = useState(false);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, user => {
      if (user) {
        dispatch(
          setUser({
            uid: user.uid,
            email: user.email || '',
            displayName: user.displayName || undefined,
            photoURL: user.photoURL || undefined,
          })
        );
      } else {
        dispatch(setUser(null));
      }
      setIsInitialized(true);
      dispatch(setLoading(false));
    });

    return () => unsubscribe();
  }, [dispatch]);

  const signIn = async (email: string, password: string) => {
    try {
      dispatch(setLoading(true));
      dispatch(setError(null));
      await signInWithEmailAndPassword(auth, email, password);
    } catch (error) {
      dispatch(
        setError(error instanceof Error ? error.message : 'Erreur de connexion')
      );
      throw error;
    } finally {
      dispatch(setLoading(false));
    }
  };

  const signUp = async (email: string, password: string) => {
    try {
      dispatch(setLoading(true));
      dispatch(setError(null));
      await createUserWithEmailAndPassword(auth, email, password);
    } catch (error) {
      dispatch(
        setError(
          error instanceof Error ? error.message : "Erreur d'inscription"
        )
      );
      throw error;
    } finally {
      dispatch(setLoading(false));
    }
  };

  const logout = async () => {
    try {
      dispatch(setLoading(true));
      await signOut(auth);
    } catch (error) {
      dispatch(
        setError(
          error instanceof Error ? error.message : 'Erreur de déconnexion'
        )
      );
      throw error;
    } finally {
      dispatch(setLoading(false));
    }
  };

  return {
    user,
    isInitialized,
    isLoading,
    isAuthenticated: !!user,
    signIn,
    signUp,
    logout,
  };
};
