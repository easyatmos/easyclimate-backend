subroutine wet_bulb_temperature(T_dry, RH, P, tolerance, A, max_iter, T_wet)
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  real(real64), intent(in) :: T_dry, RH, P, tolerance, A
  integer, intent(in) :: max_iter
  real(real64), intent(out) :: T_wet
  integer :: status

  call wet_bulb_temperature_checked(T_dry, RH, P, tolerance, A, max_iter, 0, T_wet, status)
end subroutine wet_bulb_temperature


subroutine wet_bulb_temperature_checked(T_dry, RH, P, tolerance, A, max_iter, ice, T_wet, status)
  use, intrinsic :: iso_fortran_env, only: real64
  use, intrinsic :: ieee_arithmetic, only: ieee_is_finite, ieee_value, ieee_quiet_nan
  implicit none
  real(real64), intent(in) :: T_dry, RH, P, tolerance, A
  integer, intent(in) :: max_iter, ice
  real(real64), intent(out) :: T_wet
  integer, intent(out) :: status

  ! Status: 0 = converged, 1 = invalid input, 2 = ice solution above freezing,
  ! 3 = non-convergence.
  real(real64), parameter :: e_zero = 6.1078_real64 ! hPa, shared by both curves
  real(real64), parameter :: water_b = 17.2693882_real64, water_c = 237.3_real64
  ! WMO No. 8, Eq. (4.B.3)
  real(real64), parameter :: ice_b = 22.46_real64, ice_c = 272.62_real64
  real(real64) :: ap, e_air, e_wet, residual, residual_tolerance
  real(real64) :: b, c, estimate, denominator, slope
  integer :: iteration

  T_wet = ieee_value(0.0_real64, ieee_quiet_nan)
  status = 1
  ap = A * P
  if (.not. ieee_is_finite(T_dry) .or. T_dry <= -water_c) return
  if (.not. ieee_is_finite(RH) .or. RH < 0.0_real64 .or. RH > 100.0_real64) return
  if (.not. ieee_is_finite(P) .or. P <= 0.0_real64) return
  if (.not. ieee_is_finite(A) .or. A <= 0.0_real64) return
  if (.not. ieee_is_finite(ap) .or. ap <= 0.0_real64) return
  if (.not. ieee_is_finite(tolerance) .or. tolerance <= 0.0_real64 .or. max_iter <= 0) return
  if (ice /= 0 .and. ice /= 1) return

  ! Ambient RH is relative to liquid water in both modes.
  e_air = (RH / 100.0_real64) * saturation_pressure(T_dry, water_b, water_c)
  if (ice == 1) then
     b = ice_b
     c = ice_c
     estimate = 0.0_real64
  else
     b = water_b
     c = water_c
     estimate = T_dry
  end if

  ! The residual slope is at least A * P, so this also bounds temperature error.
  residual_tolerance = min(1.0e-6_real64, tolerance * ap)
  status = 3
  do iteration = 0, max_iter
     denominator = estimate + c
     if (.not. ieee_is_finite(denominator) .or. denominator <= 0.0_real64) return
     e_wet = saturation_pressure(estimate, b, c)
     residual = e_wet - e_air + ap * (estimate - T_dry)
     if (.not. ieee_is_finite(residual)) return
     if (abs(residual) <= residual_tolerance) then
        T_wet = estimate
        status = 0
        return
     end if
     if (ice == 1 .and. iteration == 0 .and. residual < 0.0_real64) then
        status = 2
        return
     end if
     if (iteration == max_iter) exit
     slope = e_wet * b * (c / denominator) / denominator + ap
     if (.not. ieee_is_finite(slope)) return
     estimate = estimate - residual / slope
  end do

contains

  real(real64) function saturation_pressure(t, b, c)
    real(real64), intent(in) :: t, b, c
    saturation_pressure = e_zero * exp(b * (t / (t + c)))
  end function saturation_pressure

end subroutine wet_bulb_temperature_checked
