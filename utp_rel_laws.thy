section \<open> Relational Calculus Laws \<close>

theory utp_rel_laws
  imports 
    utp_rel
    utp_recursion
(*    utp_liberate *)
begin

section \<open> Cond laws \<close>

lemma cond_idem [simp]: "P \<lhd> b \<rhd> P = P"
  by pred_auto

lemma cond_sym: "P \<lhd> b \<rhd> Q = Q \<lhd> \<not>b \<rhd> P"
  by pred_auto

lemma cond_assoc: "(P \<lhd> b \<rhd> Q) \<lhd> c \<rhd> R = P \<lhd> b \<and> c \<rhd> (Q \<lhd> c \<rhd> R)"
  by pred_auto

lemma cond_distr: "P \<lhd> b \<rhd> (Q \<lhd> c \<rhd> R) = (P \<lhd> b \<rhd> Q) \<lhd> c \<rhd> (P \<lhd> b \<rhd> R)"
  by pred_auto

lemma cond_true [simp]: "P \<lhd> True \<rhd> Q = P"
  by pred_auto

lemma cond_false [simp]: "P \<lhd> False \<rhd> Q = Q"
  by pred_auto

lemma cond_reach [simp]: "P \<lhd> b \<rhd> (Q \<lhd> b \<rhd> R) = P \<lhd> b \<rhd> R"
  by pred_auto

lemma cond_disj [simp]: "P \<lhd> b \<rhd> (P \<lhd> c \<rhd> Q) = P \<lhd> b \<or> c \<rhd> Q"
  by pred_auto

(* \<odot> stands for any truth-functional operator. Any way of writing this?
lemma cond_interchange: "(P \<odot> Q) \<lhd> b \<rhd> (R \<odot> S) = (P \<lhd> b \<rhd> R) \<odot> (Q \<lhd> b \<rhd> S)"
*)

lemma comp_rcond_left_distr:
  "(P \<^bold>\<lhd> b \<^bold>\<rhd> Q) ;; R = (P ;; R) \<^bold>\<lhd> b \<^bold>\<rhd> (Q ;; R) "
  by (pred_auto)

lemma cond_seq_left_distr:
  "out\<alpha> \<sharp> b \<Longrightarrow> ((P \<lhd> b \<rhd> Q) ;; R) = ((P ;; R) \<lhd> b \<rhd> (Q ;; R))"
  by (pred_auto)

lemma cond_seq_right_distr:
  "in\<alpha> \<sharp> b \<Longrightarrow> (P ;; (Q \<lhd> b \<rhd> R)) = ((P ;; Q) \<lhd> b \<rhd> (P ;; R))"
  by (pred_auto)

text \<open> Alternative expression of conditional using assumptions and choice \<close>


lemma rcond_rassume_expand: "P \<^bold>\<lhd> b \<^bold>\<rhd> Q = (\<questiondown>b? ;; P) \<sqinter> (\<questiondown>(\<not> b)? ;; Q)"
  by pred_auto

lemma rcond_mono:  "\<lbrakk> P\<^sub>1 \<sqsubseteq> P\<^sub>2; Q\<^sub>1 \<sqsubseteq> Q\<^sub>2 \<rbrakk> \<Longrightarrow> (P\<^sub>1 \<^bold>\<lhd> b \<^bold>\<rhd> Q\<^sub>1) \<sqsubseteq> (P\<^sub>2 \<^bold>\<lhd> b \<^bold>\<rhd> Q\<^sub>2)"
  by pred_auto

lemma rcond_refine: "(P \<sqsubseteq> (Q \<lhd> b \<rhd> R)) = (P \<sqsubseteq> (b \<and> Q)\<^sub>e \<and> (P \<sqsubseteq> ((\<not>b \<and> R)\<^sub>e)))"
  by (pred_auto)

section \<open> Precondition and Postcondition Laws \<close>
  
theorem precond_equiv:
  "P = (P ;; true) \<longleftrightarrow> (out\<alpha> \<sharp> P)"
  by (pred_auto)

theorem postcond_equiv:
  "P = (true ;; P) \<longleftrightarrow> (in\<alpha> \<sharp> P)"
  by (pred_auto)

theorem precond_left_zero:
  assumes "out\<alpha> \<sharp> p" "p \<noteq> false"
  shows "(true ;; p) = true"
  using assms by (pred_auto)

(*theorem feasibile_iff_true_right_zero:
  "P ;; true = true \<longleftrightarrow> (\<exists> out\<alpha> \<bullet> P)\<^sub>u"
  oops*)
    
subsection \<open> Sequential Composition Laws \<close>
    
lemma seqr_assoc: "(P ;; Q) ;; R = P ;; (Q ;; R)"
  by (pred_auto)

lemma seqr_left_zero [simp]:
  "false ;; P = false"
  by pred_auto

lemma seqr_right_zero [simp]:
  "P ;; false = false"
  by pred_auto

lemma seqr_mono:
  "\<lbrakk> P\<^sub>1 \<sqsubseteq> P\<^sub>2; Q\<^sub>1 \<sqsubseteq> Q\<^sub>2 \<rbrakk> \<Longrightarrow> (P\<^sub>1 ;; Q\<^sub>1) \<sqsubseteq> (P\<^sub>2 ;; Q\<^sub>2)"
  by (pred_auto, blast)
    
lemma seqr_monotonic:
  "\<lbrakk> mono P; mono Q \<rbrakk> \<Longrightarrow> mono (\<lambda> X. P X ;; Q X)"
  by (pred_auto add: mono_def, blast)
  

lemma cond_seqr_mono: "mono (\<lambda>X. (P ;; X) \<^bold>\<lhd> b \<^bold>\<rhd> II)"
  by (pred_auto add: mono_def)

lemma mono_seqr_tail:
  assumes "mono F"
  shows "mono (\<lambda> X. P ;; F(X))"
  using assms by (pred_auto add: mono_def)

lemma seqr_liberate_left: "vwb_lens x \<Longrightarrow> ((P  \\ $x\<^sup><) ;; Q) = ((P ;; Q) \\ $x\<^sup><)"
  by (pred_auto)

lemma seqr_liberate_right: "vwb_lens x \<Longrightarrow> P ;; Q \\ $x\<^sup>> = (P ;; Q) \\ $x\<^sup>>"
  by pred_auto

lemma seqr_or_distl:
  "((P \<or> Q) ;; R) = ((P ;; R) \<or> (Q ;; R))"
  by (pred_auto)

lemma seqr_or_distr:
  "(P ;; (Q \<or> R)) = ((P ;; Q) \<or> (P ;; R))"
  by (pred_auto)


(* It's a shame that we can't reuse relational properties here *)

lemma seqr_and_distr_ufunc:
  "Functional P \<Longrightarrow> (P ;; (Q \<and> R)) = ((P ;; Q) \<and> (P ;; R))"
  by (rel_auto, metis single_valuedD)

lemma seqr_and_distl_uinj:
  "Injective R \<Longrightarrow> ((P \<and> Q) ;; R) = ((P ;; R) \<and> (Q ;; R))"
  by (rel_auto, auto simp add: injective_def)


lemma seqr_unfold:
  "(P ;; Q) = (\<exists> v. P\<lbrakk>\<guillemotleft>v\<guillemotright>/\<^bold>v\<^sup>>\<rbrakk> \<and> Q\<lbrakk>\<guillemotleft>v\<guillemotright>/\<^bold>v\<^sup><\<rbrakk>)\<^sub>e"
  by pred_auto

lemma seqr_unfold_heterogeneous:
  "(P ;; Q) = (\<exists> v. (pre(P\<lbrakk>\<guillemotleft>v\<guillemotright>/\<^bold>v\<^sup>>\<rbrakk>))\<^sup>< \<and> (post(Q\<lbrakk>\<guillemotleft>v\<guillemotright>/\<^bold>v\<^sup><\<rbrakk>))\<^sup>>)\<^sub>e"
  by (pred_auto)

(*
lemma seqr_middle:
  assumes "vwb_lens x"
  shows "(P ;; Q) = (\<^bold>\<exists> v \<bullet> P\<lbrakk>\<guillemotleft>v\<guillemotright>/$x\<acute>\<rbrakk> ;; Q\<lbrakk>\<guillemotleft>v\<guillemotright>/$x\<rbrakk>)"
  using assms
  by (pred_auto', metis vwb_lens_wb wb_lens.source_stability)
*)

lemma seqr_left_one_point:
  assumes "vwb_lens x"
  shows "((P \<and> ($x\<^sup>> = \<guillemotleft>v\<guillemotright>)\<^sub>u) ;; Q) = (P\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<^sup><\<rbrakk>)"
  using assms
  by (pred_auto, metis vwb_lens_wb wb_lens.get_put)

lemma seqr_right_one_point:
  assumes "vwb_lens x"
  shows "(P ;; (($x\<^sup>< = \<guillemotleft>v\<guillemotright>)\<^sub>u \<and> Q)) = (P\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<^sup><\<rbrakk>)"
  using assms
  by (pred_auto, metis vwb_lens_wb wb_lens.get_put)

lemma seqr_left_one_point_true:
  assumes "vwb_lens x"
  shows "((P \<and> ($x\<^sup>>)\<^sub>u) ;; Q) = (P\<lbrakk>true/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>true/x\<^sup><\<rbrakk>)"
  using assms
  by (pred_auto, metis (full_types) vwb_lens_wb wb_lens.get_put)

lemma seqr_left_one_point_false:
  assumes "vwb_lens x"
  shows "((P \<and> \<not>($x\<^sup>>)\<^sub>u) ;; Q) = (P\<lbrakk>false/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>false/x\<^sup><\<rbrakk>)"
  using assms by (pred_auto, metis (full_types) vwb_lens_wb wb_lens.get_put)

lemma seqr_right_one_point_true:
  assumes "vwb_lens x"
  shows "(P ;; (($x\<^sup><)\<^sub>u \<and> Q)) = (P\<lbrakk>true/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>true/x\<^sup><\<rbrakk>)"
  using assms by (pred_auto, metis (full_types) vwb_lens_wb wb_lens.get_put)

lemma seqr_right_one_point_false:
  assumes "vwb_lens x"
  shows "(P ;; (\<not>($x\<^sup><)\<^sub>u \<and> Q)) = (P\<lbrakk>false/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>false/x\<^sup><\<rbrakk>)"
  using assms by (pred_auto, metis (full_types) vwb_lens_wb wb_lens.get_put)

lemma seqr_insert_ident_left:
  assumes "vwb_lens x" "$x\<^sup>> \<sharp> P" "$x\<^sup>< \<sharp> Q"
  shows "((($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> P) ;; Q) = (P ;; Q)"
  using assms by (pred_auto, meson vwb_lens_wb wb_lens_weak weak_lens.put_get)

lemma seqr_insert_ident_right:
  assumes "vwb_lens x" "$x\<^sup>> \<sharp> P" "$x\<^sup>< \<sharp> Q"
  shows "(P ;; (($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> Q)) = (P ;; Q)"
  using assms by (pred_auto, metis (no_types, opaque_lifting) vwb_lens_def wb_lens_def weak_lens.put_get)

lemma seq_var_ident_lift:
  assumes "vwb_lens x" "$x\<^sup>> \<sharp> P" "$x\<^sup>< \<sharp> Q"
  shows "((($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> P) ;; (($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> Q)) = (($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> (P ;; Q))"
  using assms by (pred_auto, metis (no_types, lifting) vwb_lens_wb wb_lens_weak weak_lens.put_get)

lemma seqr_bool_split:
  assumes "vwb_lens x"
  shows "P ;; Q = (P\<lbrakk>true/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>true/x\<^sup><\<rbrakk> \<or> P\<lbrakk>(false)\<^sub>u/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>false/x\<^sup><\<rbrakk>)"
  using assms apply (subst seqr_middle[of x], simp_all)
  apply pred_auto
  oops

lemma cond_inter_var_split:
  assumes "vwb_lens x"
  shows "(P \<lhd> $x\<^sup>> \<rhd> Q) ;; R = (P\<lbrakk>true/x\<^sup>>\<rbrakk> ;; R\<lbrakk>true/x\<^sup><\<rbrakk> \<or> Q\<lbrakk>false/x\<^sup>>\<rbrakk> ;; R\<lbrakk>false/x\<^sup><\<rbrakk>)"
proof -
  have "(P \<lhd> $x\<^sup>> \<rhd> Q) ;; R = (((x\<^sup>>)\<^sub>u \<and> P) ;; R \<or> (\<not> (x\<^sup>>)\<^sub>u \<and> Q) ;; R)"
    by rel_simp
  also have "... = ((P \<and> (x\<^sup>>)\<^sub>u) ;; R \<or> (Q \<and> \<not>(x\<^sup>>)\<^sub>u) ;; R)"
    by (pred_auto)
  also have "... = (P\<lbrakk>true/x\<^sup>>\<rbrakk> ;; R\<lbrakk>true/x\<^sup><\<rbrakk> \<or> Q\<lbrakk>false/x\<^sup>>\<rbrakk> ;; R\<lbrakk>false/x\<^sup><\<rbrakk>)"
    apply (pred_auto add: seqr_left_one_point_true seqr_left_one_point_false assms)
    by (metis (full_types) assms vwb_lens_wb wb_lens.get_put)+
  finally show ?thesis .
qed

theorem seqr_pre_transfer: "in\<alpha> \<sharp> q \<Longrightarrow> ((P \<and> q) ;; R) = (P ;; (q\<^sup>- \<and> R))"
  by pred_auto

theorem seqr_pre_transfer':
  "((P \<and> (q\<^sup>>)\<^sub>u) ;; R) = (P ;; ((q\<^sup><)\<^sub>u \<and> R))"
  by (pred_auto)

theorem seqr_post_out: "in\<alpha> \<sharp> r \<Longrightarrow> (P ;; (Q \<and> r)) = ((P ;; Q) \<and> r)"
  by (pred_auto)

lemma seqr_post_var_out:
  shows "(P ;; (Q \<and> (x\<^sup>>)\<^sub>u)) = ((P ;; Q) \<and> (x\<^sup>>)\<^sub>u)"
  by (pred_auto)

theorem seqr_post_transfer: "out\<alpha> \<sharp> q \<Longrightarrow> (P ;; (q \<and> R)) = ((P \<and> q\<^sup>-) ;; R)"
  by (pred_auto)

lemma seqr_pre_out: "out\<alpha> \<sharp> p \<Longrightarrow> ((p \<and> Q) ;; R) = (p \<and> (Q ;; R))"
  by (pred_auto)

lemma seqr_pre_var_out:
  shows "(((x\<^sup><)\<^sub>u \<and> P) ;; Q) = ((x\<^sup><)\<^sub>u \<and> (P ;; Q))"
  by (pred_auto)

lemma seqr_true_lemma:
  "(P = (\<not> ((\<not> P) ;; true))) = (P = (P ;; true))"
  by (pred_auto)

lemma seqr_to_conj: "\<lbrakk> out\<alpha> \<sharp> P; in\<alpha> \<sharp> Q \<rbrakk> \<Longrightarrow> (P ;; Q) = (P \<and> Q)"
  by (pred_auto; blast)

lemma liberate_seq_unfold:
  "vwb_lens x \<Longrightarrow> $x \<sharp> Q \<Longrightarrow> (P \\ $x) ;; Q = (P ;; Q) \\ $x"
  apply (pred_auto add: liberate_pred_def)
  oops

(*
lemma shEx_mem_lift_seq_1 [uquant_lift]:
  assumes "out\<alpha> \<sharp> A"
  shows "((\<^bold>\<exists> x \<in> A \<bullet> P x) ;; Q) = (\<^bold>\<exists> x \<in> A \<bullet> (P x ;; Q))"
  using assms by rel_blast

lemma shEx_lift_seq_2 [uquant_lift]:
  "(P ;; (\<^bold>\<exists> x \<bullet> Q x)) = (\<^bold>\<exists> x \<bullet> (P ;; Q x))"
  by pred_auto

lemma shEx_mem_lift_seq_2 [uquant_lift]:
  assumes "in\<alpha> \<sharp> A"
  shows "(P ;; (\<^bold>\<exists> x \<in> A \<bullet> Q x)) = (\<^bold>\<exists> x \<in> A \<bullet> (P ;; Q x))"
  using assms by rel_blast*)

subsection \<open> Iterated Sequential Composition Laws \<close>
  
lemma iter_seqr_nil [simp]: "(;; i : [] \<bullet> P(i)) = II"
  by (simp add: seqr_iter_def)
    
lemma iter_seqr_cons [simp]: "(;; i : (x # xs) \<bullet> P(i)) = P(x) ;; (;; i : xs \<bullet> P(i))"
  by (simp add: seqr_iter_def)

subsection \<open> Quantale Laws \<close>

text \<open> Kept here for backwards compatibility, remove when this library catches up with the old UTP
       as most of these are already proven in Relation.thy\<close>

subsection \<open> Skip Laws \<close>
    
lemma cond_skip: "out\<alpha> \<sharp> b \<Longrightarrow> (b \<and> II) = (II \<and> b\<^sup>-)"
  by (pred_auto)

lemma pre_skip_post: "((b\<^sup><)\<^sub>u \<and> II) = (II \<and> (b\<^sup>>)\<^sub>u)"
  by (pred_auto)

lemma skip_var:
  fixes x :: "(bool \<Longrightarrow> '\<alpha>)"
  shows "(($x\<^sup><)\<^sub>u \<and> II) = (II \<and> ($x\<^sup>>)\<^sub>u)"
  by (pred_auto)

(*
text \<open>Liberate currently doesn't work on relations - it expects a lens of type 'a instead of 'a \<times> 'a\<close>
lemma skip_r_unfold:
  "vwb_lens x \<Longrightarrow> II = (($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> II \\ $x)"
  by (rel_simp, metis mwb_lens.put_put vwb_lens_mwb vwb_lens_wb wb_lens.get_put)
*)

lemma skip_r_alpha_eq:
  "II = (\<^bold>v\<^sup>< = \<^bold>v\<^sup>>)\<^sub>u"
  by (pred_auto)

(*
lemma skip_ra_unfold:
  "II\<^bsub>x;y\<^esub> = ($x\<acute> =\<^sub>u $x \<and> II\<^bsub>y\<^esub>)"
  by (pred_auto)

lemma skip_res_as_ra:
  "\<lbrakk> vwb_lens y; x +\<^sub>L y \<approx>\<^sub>L 1\<^sub>L; x \<bowtie> y \<rbrakk> \<Longrightarrow> II\<restriction>\<^sub>\<alpha>x = II\<^bsub>y\<^esub>"
  apply (pred_auto)
   apply (metis (no_types, lifting) lens_indep_def)
  apply (metis vwb_lens.put_eq)
  done
*)

section \<open> Frame laws \<close>

named_theorems frame

lemma frame_all [frame]: "\<Sigma>:[P] = P"
  by (pred_auto)

lemma frame_none [frame]: "\<emptyset>:[P] = (P \<and> II)"
  by (pred_auto add: scene_override_commute)


lemma frame_commute:
  assumes "($y\<^sup><) \<sharp> P" "($y\<^sup>>) \<sharp> P""($x\<^sup><) \<sharp> Q" "($x\<^sup>>) \<sharp> Q" "x \<bowtie> y" 
  shows "$x:[P] ;; $y:[Q] = $y:[Q] ;; $x:[P]"
  oops
  (*apply (insert assms)
  apply (pred_auto)
   apply (rename_tac s s' s\<^sub>0)
   apply (subgoal_tac "(s \<oplus>\<^sub>L s' on y) \<oplus>\<^sub>L s\<^sub>0 on x = s\<^sub>0 \<oplus>\<^sub>L s' on y")
    apply (metis lens_indep_get lens_indep_sym lens_override_def)
   apply (simp add: lens_indep.lens_put_comm lens_override_def)
  apply (rename_tac s s' s\<^sub>0)
  apply (subgoal_tac "put\<^bsub>y\<^esub> (put\<^bsub>x\<^esub> s (get\<^bsub>x\<^esub> (put\<^bsub>x\<^esub> s\<^sub>0 (get\<^bsub>x\<^esub> s')))) (get\<^bsub>y\<^esub> (put\<^bsub>y\<^esub> s (get\<^bsub>y\<^esub> s\<^sub>0))) 
                      = put\<^bsub>x\<^esub> s\<^sub>0 (get\<^bsub>x\<^esub> s')")
   apply (metis lens_indep_get lens_indep_sym)
  apply (metis lens_indep.lens_put_comm)
  done*)
 
lemma frame_miracle [simp]:
  "x:[false] = false"
  by (pred_auto)

lemma frame_skip [simp]:
  "idem_scene x \<Longrightarrow> x:[II] = II"
  by (pred_auto)

lemma frame_assign_in [frame]:
  "\<lbrakk> vwb_lens a; x \<subseteq>\<^sub>L a \<rbrakk> \<Longrightarrow> $a:[x := v] = x := v"
  apply pred_auto
  by (simp add: lens_override_def scene_override_commute)

lemma frame_conj_true [frame]:
  "\<lbrakk>-{x\<^sup><, x\<^sup>>} \<sharp> P; vwb_lens x \<rbrakk> \<Longrightarrow> (P \<and> $x:[true]) = $x:[P]"
  by (pred_auto)

(*lemma frame_is_assign [frame]:
  "vwb_lens x \<Longrightarrow> x:[$x\<acute> =\<^sub>u \<lceil>v\<rceil>\<^sub><] = x := v"
  by (pred_auto)
  *)  
lemma frame_seq [frame]:
  assumes "vwb_lens x" "-{x\<^sup>>,x\<^sup><} \<sharp> P" "-{x\<^sup><,x\<^sup>>} \<sharp> Q"
  shows "$x:[P ;; Q] = $x:[P] ;; $x:[Q]"
  unfolding frame_def apply (pred_auto)
  oops

lemma frame_assign_commute_unrest:
  assumes "vwb_lens x" "x \<bowtie> a" "$a \<sharp> v" "$x\<^sup>< \<sharp> P" "$x\<^sup>> \<sharp> P"
  shows "x := v ;; $a:[P] = $a:[P] ;; x := v"
  using assms apply (pred_auto)
  oops

lemma frame_to_antiframe [frame]:
  "\<lbrakk> x \<bowtie>\<^sub>S y; x \<squnion>\<^sub>S y = \<top>\<^sub>S \<rbrakk> \<Longrightarrow> x:[P] = (-y):[P]"
  apply pred_auto
  by (metis scene_indep_compat scene_indep_override scene_override_commute scene_override_id scene_override_union)+

lemma rel_frext_miracle [frame]: 
  "a:[false]\<^sup>+ = false"
  by (metis false_pred_def frame_miracle trancl_empty)
    
lemma rel_frext_skip [frame]: 
  "idem_scene a \<Longrightarrow> a:[II]\<^sup>+ = II"
  by (metis frame_skip rtrancl_empty rtrancl_trancl_absorb)

lemma rel_frext_seq [frame]:
  "idem_scene a \<Longrightarrow> a:[P ;; Q]\<^sup>+ = (a:[P]\<^sup>+ ;; a:[Q]\<^sup>+)"
  apply (pred_auto)
  oops (* gets nitpicked *)

(*
lemma rel_frext_assigns [frame]:
  "vwb_lens a \<Longrightarrow> a:[\<langle>\<sigma>\<rangle>\<^sub>a]\<^sup>+ = \<langle>\<sigma> \<oplus>\<^sub>s a\<rangle>\<^sub>a"
  by (pred_auto)

lemma rel_frext_rcond [frame]:
  "a:[P \<triangleleft> b \<triangleright>\<^sub>r Q]\<^sup>+ = (a:[P]\<^sup>+ \<triangleleft> b \<oplus>\<^sub>p a \<triangleright>\<^sub>r a:[Q]\<^sup>+)"
  by (pred_auto)

lemma rel_frext_commute: 
  "x \<bowtie> y \<Longrightarrow> x:[P]\<^sup>+ ;; y:[Q]\<^sup>+ = y:[Q]\<^sup>+ ;; x:[P]\<^sup>+"
  apply (pred_auto)
   apply (rename_tac a c b)
   apply (subgoal_tac "\<And>b a. get\<^bsub>y\<^esub> (put\<^bsub>x\<^esub> b a) = get\<^bsub>y\<^esub> b")
    apply (metis (no_types, hide_lams) lens_indep_comm lens_indep_get)
   apply (simp add: lens_indep.lens_put_irr2)
  apply (subgoal_tac "\<And>b c. get\<^bsub>x\<^esub> (put\<^bsub>y\<^esub> b c) = get\<^bsub>x\<^esub> b")
   apply (subgoal_tac "\<And>b a. get\<^bsub>y\<^esub> (put\<^bsub>x\<^esub> b a) = get\<^bsub>y\<^esub> b")
    apply (metis (mono_tags, lifting) lens_indep_comm)
   apply (simp_all add: lens_indep.lens_put_irr2)    
  done
    
lemma antiframe_disj [frame]: "(x:\<lbrakk>P\<rbrakk> \<or> x:\<lbrakk>Q\<rbrakk>) = x:\<lbrakk>P \<or> Q\<rbrakk>"
  by (pred_auto)

lemma antiframe_seq [frame]:
  "\<lbrakk> vwb_lens x; $x\<acute> \<sharp> P; $x \<sharp> Q \<rbrakk>  \<Longrightarrow> (x:\<lbrakk>P\<rbrakk> ;; x:\<lbrakk>Q\<rbrakk>) = x:\<lbrakk>P ;; Q\<rbrakk>"
  apply (pred_auto)
   apply (metis vwb_lens_wb wb_lens_def weak_lens.put_get)
  apply (metis vwb_lens_wb wb_lens.put_twice wb_lens_def weak_lens.put_get)
  done

lemma antiframe_copy_assign:
  "vwb_lens x \<Longrightarrow> (x := \<guillemotleft>v\<guillemotright> ;; x:\<lbrakk>P\<rbrakk> ;; x := \<guillemotleft>v\<guillemotright>) = (x := \<guillemotleft>v\<guillemotright> ;; x:\<lbrakk>P\<rbrakk>)"
  by pred_auto

  
lemma nameset_skip: "vwb_lens x \<Longrightarrow> (\<^bold>n\<^bold>s x \<bullet> II) = II\<^bsub>x\<^esub>"
  by (pred_auto, meson vwb_lens_wb wb_lens.get_put)
    
lemma nameset_skip_ra: "vwb_lens x \<Longrightarrow> (\<^bold>n\<^bold>s x \<bullet> II\<^bsub>x\<^esub>) = II\<^bsub>x\<^esub>"
  by (pred_auto)
    
declare sublens_def [lens_defs]
*)
subsection \<open> Modification laws \<close>
lemma "(rrestr x P) nmods x"
  oops

subsection \<open> Assignment Laws \<close>

text \<open>Extend the alphabet of a substitution\<close>
definition subst_aext :: "'a subst \<Rightarrow> ('a \<Longrightarrow> 'b) \<Rightarrow> 'b subst"
  where [rel]: "subst_aext \<sigma> x = (\<lambda> s. put\<^bsub>x\<^esub> s (\<sigma> (get\<^bsub>x\<^esub> s)))"

lemma assigns_subst: "(subst_aext \<sigma> fst\<^sub>L) \<dagger> \<langle>\<rho>\<rangle>\<^sub>a = \<langle>\<rho> \<circ>\<^sub>s \<sigma>\<rangle>\<^sub>a"
  by pred_auto

lemma assigns_r_comp: "(\<langle>\<sigma>\<rangle>\<^sub>a ;; P) = ((\<lambda> s. put\<^bsub>fst\<^sub>L\<^esub> s (\<sigma> (get\<^bsub>fst\<^sub>L\<^esub> s))) \<dagger> P)"
  by (pred_auto)

lemma assigns_r_feasible:
  "(\<langle>\<sigma>\<rangle>\<^sub>a ;; true) = true"
  by (pred_auto)

lemma assign_subst [usubst]:
  "\<lbrakk> vwb_lens x; vwb_lens y \<rbrakk> \<Longrightarrow>  [x\<^sup>> \<leadsto> u\<^sup><] \<dagger> (y := v) = (y, x) := ([x \<leadsto> u] \<dagger> v, u)"
  apply pred_auto
  oops

lemma assign_vacuous_skip:
  assumes "vwb_lens x"
  shows "(x := $x) = II"
  using assms by pred_auto

text \<open> The following law shows the case for the above law when $x$ is only mainly-well behaved. We
  require that the state is one of those in which $x$ is well defined using and assumption. \<close>

(*
lemma assign_vacuous_assume:
  assumes "mwb_lens x"
  shows "[&\<^bold>v \<in> \<guillemotleft>\<S>\<^bsub>x\<^esub>\<guillemotright>]\<^sup>\<top> ;; (x := &x) = [&\<^bold>v \<in> \<guillemotleft>\<S>\<^bsub>x\<^esub>\<guillemotright>]\<^sup>\<top>"
  using assms by pred_auto *)

lemma assign_simultaneous:
  assumes "vwb_lens y" "x \<bowtie> y"
  shows "(x,y) := (e, $y) = (x := e)"
  using assms by pred_auto

lemma assigns_idem: "mwb_lens x \<Longrightarrow> (x,x) := (v,u) = (x := v)"
  by pred_auto

(*
lemma assigns_cond: "\<langle>f\<rangle>\<^sub>a \<^bold>\<lhd> b \<^bold>\<rhd> \<langle>g\<rangle>\<^sub>a = \<langle>f \<^bold>\<lhd> b \<^bold>\<rhd> g\<rangle>\<^sub>a"
  by (pred_auto)*)

lemma assigns_r_conv:
  "bij f \<Longrightarrow> \<langle>f\<rangle>\<^sub>a\<^sup>- = \<langle>inv f\<rangle>\<^sub>a"
  by (pred_auto, simp_all add: bij_is_inj bij_is_surj surj_f_inv_f)

lemma assign_pred_transfer:
  assumes "$x\<^sup>< \<sharp> b" "out\<alpha> \<sharp> b"
  shows "(b \<and> x := v) = (x := v \<and> b\<^sup>-)"
  using assms apply pred_auto oops
    
lemma assign_r_comp: "x := u ;; P = P\<lbrakk>u\<^sup></x\<^sup><\<rbrakk>"
  by pred_auto

lemma assign_test: "mwb_lens x \<Longrightarrow> (x := \<guillemotleft>u\<guillemotright> ;; x := \<guillemotleft>v\<guillemotright>) = (x := \<guillemotleft>v\<guillemotright>)"
  by pred_auto

lemma assign_twice: "\<lbrakk> mwb_lens x; $x \<sharp> f \<rbrakk> \<Longrightarrow> (x := e ;; x := f) = (x := f)"
  by pred_auto
 
lemma assign_commute:
  assumes "x \<bowtie> y" "$x \<sharp> f" "$y \<sharp> e" "vwb_lens x" "vwb_lens y"
  shows "(x := e ;; y := f) = (y := f ;; x := e)"
  using assms by (pred_auto add: lens_indep_comm)

lemma assign_cond:
  assumes "out\<alpha> \<sharp> b"
  shows "(x := e ;; (P \<lhd> b \<rhd> Q)) = ((x := e ;; P) \<lhd> b \<rhd> (x := e ;; Q))"
  apply pred_auto
     defer
  oops

lemma assign_rcond:
  "(x := e ;; (P \<^bold>\<lhd> b \<^bold>\<rhd> Q)) = ((x := e ;; P) \<^bold>\<lhd> (b\<lbrakk>e/x\<rbrakk>) \<^bold>\<rhd> (x := e ;; Q))"
  by (pred_auto)

lemma assign_r_alt_def:
  fixes x :: "('a \<Longrightarrow> '\<alpha>)"
  shows "x := v = II\<lbrakk>v\<^sup></x\<^sup><\<rbrakk>"
  by (pred_auto)

lemma assigns_r_func: "functional \<langle>f\<rangle>\<^sub>a"
  by (pred_auto)

(*
lemma assigns_r_uinj: "inj\<^sub>s f \<Longrightarrow> uinj \<langle>f\<rangle>\<^sub>a"
  apply (rel_simp, simp add: inj_eq) 
    
lemma assigns_r_swap_uinj:
  "\<lbrakk> vwb_lens x; vwb_lens y; x \<bowtie> y \<rbrakk> \<Longrightarrow> uinj ((x,y) := (&y,&x))"
  by (metis assigns_r_uinj pr_var_def swap_usubst_inj)

lemma assign_unfold:
  "vwb_lens x \<Longrightarrow> (x := v) = (x\<^sup>> = v\<^sup><)"
  apply (pred_auto, auto simp add: comp_def)
  using vwb_lens.put_eq by fastforce*)

subsection \<open> Non-deterministic Assignment Laws \<close>

lemma ndet_assign_comp:
  "x \<bowtie> y \<Longrightarrow> x := * ;; y := * = (x,y) := *"
  by (pred_auto add: lens_indep.lens_put_comm)
  
lemma ndet_assign_assign:
  "\<lbrakk> vwb_lens x; $x \<sharp> e \<rbrakk> \<Longrightarrow> x := * ;; x := e = x := e"
  by pred_auto

lemma ndet_assign_refine:
  "x := * \<sqsubseteq> x := e"
  by pred_auto

subsection \<open> Converse Laws \<close>

lemma convr_invol [simp]: "p\<^sup>-\<^sup>- = p"
  by pred_auto
(*
lemma lit_convr [simp]: "(\<guillemotleft>v\<guillemotright>)\<^sup>- = \<guillemotleft>v\<guillemotright>"
  by pred_auto

lemma uivar_convr [simp]:
  fixes x :: "('a \<Longrightarrow> '\<alpha>)"
  shows "($x\<^sup><)\<^sup>- = $x\<^sup>>"
  by pred_auto

lemma uovar_convr [simp]:
  fixes x :: "('a \<Longrightarrow> '\<alpha>)"
  shows "($x\<acute>)\<^sup>- = $x"
  by pred_auto

lemma uop_convr [simp]: "(uop f u)\<^sup>- = uop f (u\<^sup>-)"
  by (pred_auto)

lemma bop_convr [simp]: "(bop f u v)\<^sup>- = bop f (u\<^sup>-) (v\<^sup>-)"
  by (pred_auto)

lemma eq_convr [simp]: "(p = q)\<^sup>- = (p\<^sup>- = q\<^sup>-)"
  by (pred_auto)

lemma not_convr [simp]: "(\<not> p)\<^sup>- = (\<not> p\<^sup>-)"
  by (pred_auto)

lemma disj_convr [simp]: "(p \<or> q)\<^sup>- = (q\<^sup>- \<or> p\<^sup>-)"
  by (pred_auto)

lemma conj_convr [simp]: "(p \<and> q)\<^sup>- = (q\<^sup>- \<and> p\<^sup>-)"
  by (pred_auto)

lemma seqr_convr [simp]: "(p ;; q)\<^sup>- = (q\<^sup>- ;; p\<^sup>-)"
  by (pred_auto)

lemma pre_convr [simp]: "\<lceil>p\<rceil>\<^sub><\<^sup>- = \<lceil>p\<rceil>\<^sub>>"
  by (pred_auto)

lemma post_convr [simp]: "\<lceil>p\<rceil>\<^sub>>\<^sup>- = \<lceil>p\<rceil>\<^sub><"
  by (pred_auto)*)

subsection \<open> Assertion and Assumption Laws \<close>


declare sublens_def [lens_defs del]
  
lemma assume_false: "\<questiondown>false? = false"
  by (pred_auto)
  
lemma assume_true: "\<questiondown>true? = II"
  by (pred_auto)
    
lemma assume_seq: "\<questiondown>b? ;; \<questiondown>c? = \<questiondown>b \<and> c?"
  by (pred_auto)

(*
lemma assert_false: "{false}\<^sub>\<bottom> = true"
  by (pred_auto)

lemma assert_true: "{true}\<^sub>\<bottom> = II"
  by (pred_auto)
    
lemma assert_seq: "{b}\<^sub>\<bottom> ;; {c}\<^sub>\<bottom> = {(b \<and> c)}\<^sub>\<bottom>"
  by (pred_auto)*)

subsection \<open> While Loop Laws \<close>

theorem while_unfold:
  "while b do P od = ((P ;; while b do P od) \<^bold>\<lhd> b \<^bold>\<rhd> II)"
proof -
  have m:"mono (\<lambda>X. (P ;; X) \<^bold>\<lhd> b \<^bold>\<rhd> II)"
    unfolding mono_def by (meson equalityE rcond_mono ref_by_def relcomp_mono)
  have "(while b do P od) = (\<nu> X \<bullet> (P ;; X) \<^bold>\<lhd> b \<^bold>\<rhd> II)"
    by (simp add: while_top_def)
  also have "... = ((P ;; (\<nu> X \<bullet> (P ;; X) \<^bold>\<lhd> b \<^bold>\<rhd> II)) \<^bold>\<lhd> b \<^bold>\<rhd> II)"
    by (subst lfp_unfold, simp_all add: m)
  also have "... = ((P ;; while b do P od) \<^bold>\<lhd> b \<^bold>\<rhd> II)"
    by (simp add: while_top_def)
  finally show ?thesis .
qed

theorem while_false: "while (false)\<^sub>e do P od = II"
  by (subst while_unfold, pred_auto)

theorem while_true: "while (true)\<^sub>e do P od = false"
  apply (simp add: while_top_def alpha)
  apply (rule antisym)
  apply (rule lfp_lowerbound)
  apply (pred_auto)+
  done

theorem while_bot_unfold:
  "while\<^sub>\<bottom> b do P od = ((P ;; while\<^sub>\<bottom> b do P od) \<^bold>\<lhd> b \<^bold>\<rhd> II)"
proof -
  have m:"mono (\<lambda>X. (P ;; X) \<^bold>\<lhd> b \<^bold>\<rhd> II)"
    unfolding mono_def by (meson equalityE rcond_mono ref_by_def relcomp_mono)
  have "(while\<^sub>\<bottom> b do P od) = (\<mu> X \<bullet> (P ;; X) \<^bold>\<lhd> b \<^bold>\<rhd> II)"
    by (simp add: while_bot_def)
  also have "... = ((P ;; (\<mu> X \<bullet> (P ;; X) \<^bold>\<lhd> b \<^bold>\<rhd> II)) \<^bold>\<lhd> b \<^bold>\<rhd> II)"
    by (subst gfp_unfold, simp_all add: m)
  also have "... = ((P ;; while\<^sub>\<bottom> b do P od) \<^bold>\<lhd> b \<^bold>\<rhd> II)"
    by (simp add: while_bot_def)
  finally show ?thesis .
qed

theorem while_bot_false: "while\<^sub>\<bottom> (false)\<^sub>e do P od = II"
  by (pred_auto add: while_bot_def gfp_const)

theorem while_bot_true: "while\<^sub>\<bottom> (true)\<^sub>e do P od = (\<mu> X \<bullet> P ;; X)"
  by (pred_auto add: while_bot_def)

text \<open> An infinite loop with a feasible body corresponds to a program error (non-termination). \<close>

theorem while_infinite: "P ;; true = true \<Longrightarrow> while\<^sub>\<bottom> (true)\<^sub>e do P od = true"
  apply (rule antisym)
   apply (simp add: true_pred_def)
    apply (pred_auto add: gfp_upperbound while_bot_true)
  done

subsection \<open> Algebraic Properties \<close>

interpretation upred_semiring: semiring_1 
  where times = "(;;)" and one = Id and zero = false_pred and plus = "Lattices.sup"
  by (unfold_locales; pred_auto+)

declare upred_semiring.power_Suc [simp del]

text \<open> We introduce the power syntax derived from semirings \<close>

text \<open> Set up transfer tactic for powers \<close>
unbundle utp_lattice_syntax

lemma Sup_power_expand:
  fixes P :: "nat \<Rightarrow> 'a::complete_lattice"
  shows "P(0) \<sqinter> (\<Sqinter>i. P(i+1)) = (\<Sqinter>i. P(i))"
proof -
  have "UNIV = insert (0::nat) {1..}"
    by auto
  moreover have "(\<Sqinter>i. P(i)) = \<Sqinter> (P ` UNIV)"
    by (blast)
  moreover have "\<Sqinter> (P ` insert 0 {1..}) = P(0) \<sqinter> \<Sqinter> (P ` {1..})"
    by (simp)
  moreover have "\<Sqinter> (P ` {1..}) = (\<Sqinter>i. P(i+1))"
    sorry
  ultimately show ?thesis
    by simp
qed
(*
lemma Sup_upto_Suc: "(\<Sqinter>i\<in>{0..Suc n}. P \<^bold>^ i) = (\<Sqinter>i\<in>{0..n}. P \<^bold>^ i) \<sqinter> P \<^bold>^ Suc n"
proof -
  have "(\<Sqinter>i\<in>{0..Suc n}. P \<^bold>^ i) = (\<Sqinter>i\<in>insert (Suc n) {0..n}. P \<^bold>^ i)"
    by (simp add: atLeast0_atMost_Suc)
  also have "... = P \<^bold>^ Suc n \<sqinter> (\<Sqinter>i\<in>{0..n}. P \<^bold>^ i)"
    by (simp)
  finally show ?thesis
    by (simp add: Lattices.sup_commute)
qed
*)
text \<open> The following two proofs are adapted from the AFP entry 
  \href{https://www.isa-afp.org/entries/Kleene_Algebra.shtml}{Kleene Algebra}. 
  See also~\cite{Armstrong2012,Armstrong2015}. \<close>

lemma upower_inductl: "Q \<sqsubseteq> ((P ;; Q) \<sqinter> R) \<Longrightarrow> Q \<sqsubseteq> P ^^ n ;; R"
proof (induct n)
  case 0
  then show ?case by (auto)
next
  case (Suc n)
  then show ?case
    by (smt (verit, del_insts) ref_lattice.inf.absorb_iff1 ref_lattice.le_infE relcomp_distrib relpow.simps(2) relpow_commute seqr_assoc)
qed

lemma upower_inductr:
  assumes "Q \<sqsubseteq> R \<sqinter> (Q ;; P)"
  shows "Q \<sqsubseteq> R ;; (P ^^ n)"
using assms proof (induct n)
  case 0
  then show ?case by auto
next
  case (Suc n)
  then show ?case
    by (pred_auto, blast)
qed

lemma SUP_atLeastAtMost_first:
  fixes P :: "nat \<Rightarrow> 'a::complete_lattice"
  assumes "m \<le> n"
  shows "(\<Sqinter>i\<in>{m..n}. P(i)) = P(m) \<sqinter> (\<Sqinter>i\<in>{Suc m..n}. P(i))"
  by (metis SUP_insert assms atLeastAtMost_insertL)
    
lemma upower_seqr_iter: "P ^^ n = (;; Q : replicate n P \<bullet> Q)"
  apply (induct n)
  by (simp, metis iter_seqr_cons relpow.simps(2) relpow_commute replicate_Suc)

subsection \<open> Omega \<close>

definition uomega :: "'\<alpha> rel \<Rightarrow> '\<alpha> rel" ("_\<^sup>\<omega>" [999] 999) where
"P\<^sup>\<omega> = (\<mu> X \<bullet> P ;; X)"

subsection \<open> Relation Algebra Laws \<close>

theorem seqr_disj_cancel: "((P\<^sup>- ;; (\<not>(P ;; Q))) \<or> (\<not>Q)) = (\<not>Q)"
  by (pred_auto)

subsection \<open> Kleene Algebra Laws \<close>

theorem ustar_sub_unfoldl: "P\<^sup>* \<sqsubseteq> II \<sqinter> (P;;P\<^sup>*)"
  by rel_force
    
theorem rtrancl_inductl:
  assumes "Q \<sqsubseteq> R" "Q \<sqsubseteq> P ;; Q"
  shows "Q \<sqsubseteq> P\<^sup>* ;; R"
proof -
  have "P\<^sup>* ;; R = (\<Sqinter> i. P ^^ i ;; R)"
    by (simp add: relcomp_UNION_distrib2 rtrancl_is_UN_relpow)
  also have "Q \<sqsubseteq> ..."
    by (simp add: assms ref_lattice.INF_greatest upower_inductl)
  finally show ?thesis .
qed

theorem rtrancl_inductr:
  assumes "Q \<sqsubseteq> R" "Q \<sqsubseteq> Q ;; P"
  shows "Q \<sqsubseteq> R ;; P\<^sup>*"
proof -
  have "R ;; P\<^sup>* = (\<Sqinter> i. R ;; P ^^ i)"
    by (metis rtrancl_is_UN_relpow relcomp_UNION_distrib)
  also have "Q \<sqsubseteq> ..."
    by (simp add: assms ref_lattice.INF_greatest upower_inductr)
  finally show ?thesis .
qed

lemma rtrancl_refines_nu: "(\<nu> X \<bullet> (P ;; X) \<sqinter> II) \<sqsubseteq> P\<^sup>*"
proof -
  have mono_X: "mono (\<lambda> X. (P ;; X) \<sqinter> II)"
    by (smt (verit, del_insts) Un_mono monoI relcomp_distrib subset_Un_eq sup.idem)
  { 
    fix a b assume "(a, b) \<in> P\<^sup>*"
    then have "(a, b) \<in> (\<nu> X \<bullet> (P ;; X) \<sqinter> II)"
      apply (induct rule: converse_rtrancl_induct)
      using mono_X lfp_unfold by blast+
  }
  then show ?thesis
    by pred_auto
qed

lemma rtrancl_as_nu: "P\<^sup>* = (\<nu> X \<bullet> (P ;; X) \<sqinter> II)"
proof (rule antisym)
  show "P\<^sup>* \<subseteq> (\<nu> X \<bullet> P ;; X \<union> II)"
    using rtrancl_refines_nu by pred_auto
  show "(\<nu> X \<bullet> P ;; X \<union> II) \<subseteq> P\<^sup>*"
    by (metis dual_order.refl lfp_lowerbound rtrancl_trancl_reflcl trancl_unfold_left)
qed

lemma rtrancl_unfoldl: "P\<^sup>* = II \<sqinter> (P ;; P\<^sup>*)"
  apply (simp add: rtrancl_as_nu)
  apply (subst lfp_unfold)
   apply (rule monoI)
   apply (pred_auto)+
  done

text \<open> While loop can be expressed using Kleene star \<close>
(*
lemma while_star_form:
  "while b do P od = (P \<^bold>\<lhd> b \<^bold>\<rhd> II)\<^sup>* ;; \<questiondown>(\<not>b)?"
proof -
  have 1: "Continuous (\<lambda>X. P ;; X \<^bold>\<lhd> b \<^bold>\<rhd> II)"
    by (pred_auto)
  have "while b do P od = (\<Sqinter>i. ((\<lambda>X. P ;; X \<^bold>\<lhd> b \<^bold>\<rhd> II) ^^ i) false)"
    by (simp add: "1" false_upred_def sup_continuous_Continuous sup_continuous_lfp while_top_def)
  also have "... = ((\<lambda>X. P ;; X \<^bold>\<lhd> b \<^bold>\<rhd> II) ^^ 0) false \<sqinter> (\<Sqinter>i. ((\<lambda>X. P ;; X \<^bold>\<lhd> b \<^bold>\<rhd> II) ^^ (i+1)) false)"
    by (subst Sup_power_expand, simp)
  also have "... = (\<Sqinter>i. ((\<lambda>X. P ;; X \<^bold>\<lhd> b \<^bold>\<rhd> II) ^^ (i+1)) false)"
    by (simp)
  also have "... = (\<Sqinter>i. (P \<^bold>\<lhd> b \<^bold>\<rhd> II)\<^bold>^i ;; (false \<^bold>\<lhd> b \<^bold>\<rhd> II))"
  proof (rule SUP_cong, simp_all)
    fix i
    show "P ;; ((\<lambda>X. P ;; X \<^bold>\<lhd> b \<^bold>\<rhd> II) ^^ i) false \<^bold>\<lhd> b \<^bold>\<rhd> II = (P \<^bold>\<lhd> b \<^bold>\<rhd> II) \<^bold>^ i ;; (false \<^bold>\<lhd> b \<^bold>\<rhd> II)"
    proof (induct i)
      case 0
      then show ?case by simp
    next
      case (Suc i)
      then show ?case
        by (simp add: upred_semiring.power_Suc)
           (metis (no_types, lifting) RA1 comp_cond_left_distr cond_L6 upred_semiring.mult.left_neutral)
    qed
  qed
  also have "... = (\<Sqinter>i\<in>{0..} \<bullet> (P \<^bold>\<lhd> b \<^bold>\<rhd> II)\<^bold>^i ;; [(\<not>b)]\<^sup>\<top>)"
    by (pred_auto)
  also have "... = (P \<^bold>\<lhd> b \<^bold>\<rhd> II)\<^sup>\<star> ;; [(\<not>b)]\<^sup>\<top>"
    by (metis seq_UINF_distr ustar_def)
  finally show ?thesis .
qed
*)
  
subsection \<open> Omega Algebra Laws \<close>

lemma uomega_induct: "P ;; P\<^sup>\<omega> \<sqsubseteq> P\<^sup>\<omega>"
  by (metis gfp_unfold monoI ref_by_set_def relcomp_mono subset_refl uomega_def)

subsection \<open> Refinement Laws \<close>

lemma skip_r_refine: "(p \<Rightarrow> p) \<sqsubseteq> II"
  by pred_auto

lemma conj_refine_left: "(Q \<Rightarrow> P) \<sqsubseteq> R \<Longrightarrow> P \<sqsubseteq> (Q \<and> R)"
  by (pred_auto)

lemma pre_weak_rel:
  assumes "`p \<longrightarrow> I`"
  and     "(I \<longrightarrow> q)\<^sub>u \<sqsubseteq> P"
  shows "(p \<longrightarrow> q)\<^sub>u \<sqsubseteq> P"
  using assms by(pred_auto)

(*
lemma cond_refine_rel: 
  assumes "S \<sqsubseteq> (\<lceil>b\<rceil>\<^sub>< \<and> P)" "S \<sqsubseteq> (\<lceil>\<not>b\<rceil>\<^sub>< \<and> Q)"
  shows "S \<sqsubseteq> P \<^bold>\<lhd> b \<^bold>\<rhd> Q"
  by (metis aext_not assms(1) assms(2) cond_def lift_rcond_def utp_pred_laws.le_sup_iff)

lemma seq_refine_pred:
  assumes "(\<lceil>b\<rceil>\<^sub>< \<Rightarrow> \<lceil>s\<rceil>\<^sub>>) \<sqsubseteq> P" and "(\<lceil>s\<rceil>\<^sub>< \<Rightarrow> \<lceil>c\<rceil>\<^sub>>) \<sqsubseteq> Q"
  shows "(\<lceil>b\<rceil>\<^sub>< \<Rightarrow> \<lceil>c\<rceil>\<^sub>>) \<sqsubseteq> (P ;; Q)"
  using assms by pred_auto
    
lemma seq_refine_unrest:
  assumes "out\<alpha> \<sharp> b" "in\<alpha> \<sharp> c"
  assumes "(b \<Rightarrow> \<lceil>s\<rceil>\<^sub>>) \<sqsubseteq> P" and "(\<lceil>s\<rceil>\<^sub>< \<Rightarrow> c) \<sqsubseteq> Q"
  shows "(b \<Rightarrow> c) \<sqsubseteq> (P ;; Q)"
  using assms by rel_blast 
    
subsection \<open> Preain and Postge Laws \<close>

named_theorems prepost

lemma Pre_conv_Post [prepost]:
  "Pre(P\<^sup>-) = Post(P)"
  by (pred_auto)

lemma Post_conv_Pre [prepost]:
  "Post(P\<^sup>-) = Pre(P)"
  by (pred_auto)  

lemma Pre_skip [prepost]:
  "Pre(II) = true"
  by (pred_auto)

lemma Pre_assigns [prepost]:
  "Pre(\<langle>\<sigma>\<rangle>\<^sub>a) = true"
  by (pred_auto)
   
lemma Pre_miracle [prepost]:
  "Pre(false) = false"
  by (pred_auto)

lemma Pre_assume [prepost]:
  "Pre([b]\<^sup>\<top>) = b"
  by (pred_auto)
    
lemma Pre_)seq:
  "Pre(P ;; Q) = Pre(P ;; [Pre(Q)]\<^sup>\<top>)"
  by (pred_auto)
    
lemma Pre_disj [prepost]:
  "Pre(P \<or> Q) = (Pre(P) \<or> Pre(Q))"
  by (pred_auto)

lemma Pre_inf [prepost]:
  "Pre(P \<sqinter> Q) = (Pre(P) \<or> Pre(Q))"
  by (pred_auto)

text \<open> If P uses on the variables in @{term a} and @{term Q} does not refer to the variables of
  @{term "$a\<acute>"} then we can distribute. \<close>

lemma Pre_conj_indep [prepost]: "\<lbrakk> {$a,$a\<acute>} \<natural> P; $a\<acute> \<sharp> Q; vwb_lens a \<rbrakk> \<Longrightarrow> Pre(P \<and> Q) = (Pre(P) \<and> Pre(Q))"
  by (pred_auto, metis lens_override_def lens_override_idem)

lemma assume_Pre [prepost]:
  "[Pre(P)]\<^sup>\<top> ;; P = P"
  by (pred_auto)
*)

end
