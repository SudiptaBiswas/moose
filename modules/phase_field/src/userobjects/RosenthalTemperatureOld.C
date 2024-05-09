#include "RosenthalTemperatureOld.h"
#include "MooseMesh.h"
#include "AuxiliarySystem.h"
#include "libmesh/utility.h"

registerMooseObject("MalamuteApp", RosenthalTemperatureOld);

InputParameters
RosenthalTemperatureOld::validParams()
{
  InputParameters params = GeneralUserObject::validParams();
  params.addRequiredParam<Real>("thermal_conductivity", "thermal conductivity of the material");
  params.addRequiredParam<Real>("specific_heat", "specific heat of the material");
  params.addRequiredParam<Real>("density", "density of the material");
  params.addRequiredParam<Real>("power", "applied power as external heat");
  params.addRequiredParam<Real>("velocity", "velocity of the moving heat source");
  params.addRequiredParam<Real>("melting_temp", "melting temperature of the material");
  params.addRequiredParam<Real>("ambient_temp", "minimum temperature of the surrounding material");
  params.addParam<Real>("x0", 0, "initial location of the moving source center in x-direction");
  params.addParam<Real>("y0", 0, "initial location of the moving source center in y-direction");
  params.addParam<Real>(
      "maximum_temp",
      -273,
      "maximum allowable temperature in the field. Default is melting temperature + 10");

  return params;
}

RosenthalTemperatureOld::RosenthalTemperatureOld(const InputParameters & parameters)
  : GeneralUserObject(parameters),
    _kappa(parameters.get<Real>("thermal_conductivity")),
    _rho(parameters.get<Real>("density")),
    _cp(parameters.get<Real>("specific_heat")),
    _Q(parameters.get<Real>("power")),
    _Vp(parameters.get<Real>("velocity")),
    _x0(parameters.get<Real>("x0")),
    _y0(parameters.get<Real>("y0")),
    _Tm(parameters.get<Real>("melting_temp")),
    _To(parameters.get<Real>("ambient_temp")),
    _Tmax(parameters.get<Real>("maximum_temp"))
{
  if (_Tmax == -273)
  {
    _Tmax = _Tm + 10;
  }
}

Real
RosenthalTemperatureOld::thermal_conductivity() const
{
  return _kappa;
}

Real
RosenthalTemperatureOld::density() const
{
  return _rho;
}

Real
RosenthalTemperatureOld::specific_heat() const
{
  return _cp;
}

Real
RosenthalTemperatureOld::power() const
{
  return _Q;
}

Real
RosenthalTemperatureOld::velocity() const
{
  return _Vp;
}

Real
RosenthalTemperatureOld::initial_x() const
{
  return _x0;
}

Real
RosenthalTemperatureOld::initial_y() const
{
  return _y0;
}

Real
RosenthalTemperatureOld::melting_temp() const
{
  return _Tm;
}

Real
RosenthalTemperatureOld::ambient_temp() const
{
  return _To;
}

Real
RosenthalTemperatureOld::maximum_temp() const
{
  return _Tmax;
}

Real
RosenthalTemperatureOld::value(const Point & p) const
{
  Real xt = p(0) - _x0 - _Vp * _t;
  Real yt = p(1) - _y0;
  Real R = std::sqrt((xt * xt) + (yt * yt) + (p(2) * p(2)));
  Real temperature = _To + (_Q / (2 * libMesh::pi * _kappa * R)) *
                               std::exp(-1 * (_Vp) * (R + xt) / (2 * _kappa / (_rho * _cp)));

  if (temperature >= _Tmax)
  {
    temperature = _Tmax;
  }
  return temperature;
}

Real
RosenthalTemperatureOld::spatialValue(const Point & p) const
{
  Real xt = p(0) - _x0 - _Vp * _t;
  Real yt = p(1) - _y0;
  Real R = std::sqrt((xt * xt) + (yt * yt) + (p(2) * p(2)));
  Real temperature = _To + (_Q / (2 * libMesh::pi * _kappa * R)) *
                               std::exp(-1 * (_Vp) * (R + xt) / (2 * _kappa / (_rho * _cp)));

  if (temperature >= _Tmax)
  {
    temperature = _Tmax;
  }

  return temperature;
}
