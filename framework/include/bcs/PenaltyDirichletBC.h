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
#ifndef PENALTYDIRICHLETBC_H
#define PENALTYDIRICHLETBC_H

#include "IntegratedBC.h"

class PenaltyDirichletBC;
class Function;

template<>
InputParameters validParams<PenaltyDirichletBC>();

/**
 * A different approach to applying Dirichlet BCs
 *
 * uses \f$\int(p u \cdot \phi)=\int(p f \cdot \phi)\f$ on \f$d\omega\f$
 *
 */

class PenaltyDirichletBC : public IntegratedBC
{
public:
  PenaltyDirichletBC(const InputParameters & parameters);

  virtual ~PenaltyDirichletBC() {}

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

private:
  Real _p;
  Real _v;
=======
public:

  virtual void calc_physical_volfrac();
  virtual void calc_mf_weights();
  virtual Point get_origin(unsigned int plane_id, MeshBase* displaced_mesh=NULL) const;
  virtual Point get_normal(unsigned int plane_id, MeshBase* displaced_mesh=NULL) const;
  virtual const EFAelement * get_efa_elem() const;
  virtual unsigned int num_cut_planes() const;

private:

  void new_weight_mf(unsigned int nen, unsigned int nqp, std::vector<Point> &elem_nodes,
                     std::vector<std::vector<Real> > &wsg);
  void partial_gauss(unsigned int nen, std::vector<std::vector<Real> > &tsg);
  void solve_mf(unsigned int nen, unsigned int nqp, std::vector<Point> &elem_nodes,
                std::vector<std::vector<Real> > &tsg, std::vector<std::vector<Real> > &wsg);
>>>>>>> add MF & direct quadrature rule, remove xfem_volfrac in solid mechanics & heat kernels,:framework/include/XFEM/XFEMCutElem2D.h
};

#endif
