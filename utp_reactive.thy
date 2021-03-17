theory utp_reactive
  imports utp_designs
begin

alphabet 'e rea_vars = des_vars +
  wait :: bool
  tr   :: "'e list"

declare des_vars.splits [alpha_splits del]
declare des_vars.splits [alpha_splits]

definition [pred]: "R1(P) = ((tr\<^sup>< \<le> tr\<^sup>>)\<^sub>u \<and> P)"

definition [pred]: "R3(P) = (II \<lhd> wait\<^sup>< \<rhd> P)"

lemma "R1(R1(P)) = R1(P)"
  by (pred_auto)

lemma "(tr\<^sup>< \<le> tr\<^sup>>)\<^sub>u \<^bold>; (tr\<^sup>< \<le> tr\<^sup>>)\<^sub>u = (tr\<^sup>< \<le> tr\<^sup>>)\<^sub>u"
  by (pred_auto)

end