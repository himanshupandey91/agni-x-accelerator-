# AGNI-X Mathematical Models

## 1. Clock Frequency

f = 1 / T_cycle

T_cycle = T_logic + T_interconnect + T_setup + T_skew

## 2. Dynamic Power

P_dynamic = α × C_total × V² × f

C_total = C_gate + C_diffusion + C_interconnect + C_fringe

## 3. Energy per MAC

E_MAC = C_switching × V²

E_MAC = P_total / (f × N_MAC)

## 4. Throughput

Throughput = N_MAC × f × Util × IPC

## 5. Efficiency

η = Throughput / P_total

η = 1 / E_MAC

## 6. Memory Bandwidth

BW_total = Σ (Width_i × Data_rate_i)

## 7. Power Density

ρ_power = P_total / A_die

## 8. Junction Temperature

T_junction = T_ambient + P_total × (Ψ_JC + Θ_CA)

## 9. AGNI-X Performance Advantage

Adv_perf =
(Throughput_agni / Power_agni) /
(Throughput_nv / Power_nv)

## 10. Cost Advantage

Adv_cost =
(Price_nv - Price_agni) / Price_nv × 100%

## 11. Important Validation Status

These equations document the mathematical models used in the current AGNI-X design.

Numerical performance and power values are treated as design projections or simulations unless independently reproduced and experimentally validated.

Source: AGNI-X Complete Formula Sheet.
