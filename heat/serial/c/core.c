/* Main solver routines for heat equation solver */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "heat.h"

/* Update the temperature values using five-point stencil */
void evolve(field *curr, field *prev, double a, double dt)
{
    int i, j;
    double dx2, dy2;
    int nx, ny;
    
    /* Determine the temperature field at next time step
     * As we have fixed boundary conditions, the outermost gridpoints
     * are not updated. */
    dx2 = prev->dx * prev->dx;
    dy2 = prev->dy * prev->dy;
    nx = prev->nx;
    ny = prev->ny;

    for (i = 1; i < nx+1; i++){
        for (j =1; j<ny+1; j++){
            curr->data[i][j] = prev->data[i][j]+dt*a*(
                (prev->data[i-1][j]+prev->data[i+1][j]-2*prev->data[i][j])/dx2 + 
                (prev->data[i][j-1]+prev->data[i][j+1]-2*prev->data[i][j])/dy2
                );
        }
    }
    for (i = 0; i<nx+2; i++){
         curr->data[i][0]=curr->data[i][1];
         curr->data[i][n+1]=curr->data[i][n];
    }    
    for (j = 0; j<ny+2; j++){
         curr->data[0][j]=curr->data[1][j];
         curr->data[ny+1][j]=curr->data[ny][j];
    }
    // DONE

}


