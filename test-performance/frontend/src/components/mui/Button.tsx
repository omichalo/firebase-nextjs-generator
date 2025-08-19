import { Button as MuiButton, ButtonProps } from '@mui/material';
import { forwardRef } from 'react';

export interface CustomButtonProps extends ButtonProps {
  variant?: 'text' | 'outlined' | 'contained';
  size?: 'small' | 'medium' | 'large';
  color?: 'primary' | 'secondary' | 'error' | 'info' | 'success' | 'warning';
}

export const Button = forwardRef<HTMLButtonElement, CustomButtonProps>(
  ({ children, ...props }, ref) => {
    return (
      <MuiButton ref={ref} {...props}>
        {children}
      </MuiButton>
    );
  }
);

Button.displayName = 'Button'; 