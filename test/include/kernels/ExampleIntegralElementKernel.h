/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/
#ifndef EXAMPLEINTEGRALELEMENTKERNEL_H
#define EXAMPLEINTEGRALELEMENTKERNEL_H

#include "Kernel.h"
#include "ExampleIntegralElementUserObject.h"

class ExampleIntegralElementKernel : public Kernel
{
public:
  ExampleIntegralElementKernel(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const ExampleIntegralElementUserObject & _shp;
  const Real & _shp_integral;
  const Real & _shp_dintdu;
  const Real & _shp_dintdv;

  unsigned int _u_var;
  const std::vector<dof_id_type> & _u_dofs;
  unsigned int _v_var;
  const std::vector<dof_id_type> & _v_dofs;
};

template<>
InputParameters validParams<ExampleIntegralElementKernel>();

#endif //ExampleIntegralElementKernel_H
