section \<open> Relational Calculus Laws \<close>

theory utp_rel_laws
  imports 
    utp_rel
    utp_recursion
    utp_liberate
begin

lemma comp_cond_left_distr:
  "(P \<^bold>\<lhd> b \<^bold>\<rhd> Q) ;; R = (P ;; R) \<^bold>\<lhd> b \<^bold>\<rhd> (Q ;; R) "
  by (rel_auto)

lemma cond_seq_left_distr:
  "out\<alpha> \<sharp> b \<Longrightarrow> ((P \<lhd> b \<rhd> Q) ;; R) = ((P ;; R) \<lhd> b \<rhd> (Q ;; R))"
  by (rel_auto, blast)

lemma cond_seq_right_distr:
  "in\<alpha> \<sharp> b \<Longrightarrow> (P ;; (Q \<lhd> b \<rhd> R)) = ((P ;; Q) \<lhd> b \<rhd> (P ;; R))"
  by (rel_auto, blast)

text \<open> Alternative expression of conditional using assumptions and choice \<close>

lemma rcond_rassume_expand: "P \<^bold>\<lhd> b \<^bold>\<rhd> Q = (\<questiondown>b? ;; P) \<union> (\<questiondown>(\<not> b)? ;; Q)"
  by rel_auto

lemma rcond_mono:  "\<lbrakk> P\<^sub>1 \<sqsubseteq> P\<^sub>2; Q\<^sub>1 \<sqsubseteq> Q\<^sub>2 \<rbrakk> \<Longrightarrow> (P\<^sub>1 \<^bold>\<lhd> b \<^bold>\<rhd> Q\<^sub>1) \<sqsubseteq> (P\<^sub>2 \<^bold>\<lhd> b \<^bold>\<rhd> Q\<^sub>2)"
  by rel_auto

subsection \<open> Precondition and Postcondition Laws \<close>
  
theorem precond_equiv:
  "P = (P ;; true) \<longleftrightarrow> (out\<alpha> \<sharp> P)"
  by (rel_auto)

theorem postcond_equiv:
  "P = (true ;; P) \<longleftrightarrow> (in\<alpha> \<sharp> P)"
  by (rel_auto)

theorem precond_left_zero:
  assumes "out\<alpha> \<sharp> p" "p \<noteq> false"
  shows "(true ;; p) = true"
  using assms by (rel_auto)

(*theorem feasibile_iff_true_right_zero:
  "P ;; true = true \<longleftrightarrow> (\<exists> out\<alpha> \<bullet> P)\<^sub>u"
  oops*)
    
subsection \<open> Sequential Composition Laws \<close>
    
lemma seqr_assoc: "(P ;; Q) ;; R = P ;; (Q ;; R)"
  by (rel_auto)

lemma seqr_left_zero [simp]:
  "false ;; P = false"
  by pred_auto

lemma seqr_right_zero [simp]:
  "P ;; false = false"
  by pred_auto

lemma seqr_mono:
  "\<lbrakk> P\<^sub>1 \<sqsubseteq> P\<^sub>2; Q\<^sub>1 \<sqsubseteq> Q\<^sub>2 \<rbrakk> \<Longrightarrow> (P\<^sub>1 ;; Q\<^sub>1) \<sqsubseteq> (P\<^sub>2 ;; Q\<^sub>2)"
  by (rel_auto)
    
lemma seqr_monotonic:
  "\<lbrakk> mono P; mono Q \<rbrakk> \<Longrightarrow> mono (\<lambda> X. P X ;; Q X)"
  by (simp add: mono_def relcomp_mono)

(*
lemma Monotonic_seqr_tail [closure]:
  assumes "Monotonic F"
  shows "Monotonic (\<lambda> X. P ;; F(X))"
  by (simp add: assms monoD monoI seqr_mono) *)

lemma seqr_liberate_left:
  "(((P :: 'a \<leftrightarrow> 'b) \\ $x\<^sup><) ;; Q) = ((P ;; Q) \\ $x\<^sup><)"
  apply (expr_simp add: liberate_pred_def)
  oops

lemma seqr_liberate_right:
  "P ;; Q \\ $x\<^sup>> = (P ;; Q) \\ $x\<^sup>>"
proof (rel_simp add: set_pred_def)
  have "$x\<^sup>> \<sharp> Q \\ $x\<^sup>>"
    using unrest_liberate_pred by auto
  then have "$x\<^sup>> \<sharp> P ;; Q \\ $x\<^sup>>"
    apply rel_simp
  oops

lemma seqr_or_distl:
  "((P \<or> Q) ;; R) = ((P ;; R) \<or> (Q ;; R))"
  by (rel_auto)

lemma seqr_or_distr:
  "(P ;; (Q \<or> R)) = ((P ;; Q) \<or> (P ;; R))"
  by (rel_auto)

(*
lemma seqr_and_distr_ufunc:
  "ufunctional P \<Longrightarrow> (P ;; (Q \<and> R)) = ((P ;; Q) \<and> (P ;; R))"
  by (rel_auto)

lemma seqr_and_distl_uinj:
  "uinj R \<Longrightarrow> ((P \<and> Q) ;; R) = ((P ;; R) \<and> (Q ;; R))"
  by (rel_auto)

lemma seqr_unfold:
  "(P ;; Q) = (\<^bold>\<exists> v \<bullet> P\<lbrakk>\<guillemotleft>v\<guillemotright>/$\<^bold>v\<acute>\<rbrakk> \<and> Q\<lbrakk>\<guillemotleft>v\<guillemotright>/$\<^bold>v\<rbrakk>)"
  by (rel_auto)

lemma seqr_unfold_heterogeneous:
  "(P ;; Q) = (pre(P\<lbrakk>\<guillemotleft>v\<guillemotright>//$v\<^sup>>\<rbrakk>))\<^sup>< \\ v\<^sup>< \<and> (post(Q\<lbrakk>\<guillemotleft>v\<guillemotright>/$v\<rbrakk>))\<^sup>>)"
  by (rel_auto)

lemma seqr_middle:
  assumes "vwb_lens x"
  shows "(P ;; Q) = (\<^bold>\<exists> v \<bullet> P\<lbrakk>\<guillemotleft>v\<guillemotright>/$x\<acute>\<rbrakk> ;; Q\<lbrakk>\<guillemotleft>v\<guillemotright>/$x\<rbrakk>)"
  using assms
  by (rel_auto', metis vwb_lens_wb wb_lens.source_stability)
*)

lemma seqr_left_one_point:
  assumes "vwb_lens x"
  shows "((P \<and> ($x\<^sup>> = \<guillemotleft>v\<guillemotright>)\<^sub>u) ;; Q) = (P\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<^sup><\<rbrakk>)"
  using assms
  by (rel_auto, metis vwb_lens_wb wb_lens.get_put)

lemma seqr_right_one_point:
  assumes "vwb_lens x"
  shows "(P ;; (($x\<^sup>< = \<guillemotleft>v\<guillemotright>)\<^sub>u \<and> Q)) = (P\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<^sup><\<rbrakk>)"
  using assms
  by (rel_auto, metis vwb_lens_wb wb_lens.get_put)

lemma seqr_left_one_point_true:
  assumes "vwb_lens x"
  shows "((P \<and> ($x\<^sup>>)\<^sub>u) ;; Q) = (P\<lbrakk>true/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>true/x\<^sup><\<rbrakk>)"
  using assms
  by (rel_auto, metis (full_types) vwb_lens_wb wb_lens.get_put)

lemma seqr_left_one_point_false:
  assumes "vwb_lens x"
  shows "((P \<and> \<not>($x\<^sup>>)\<^sub>u) ;; Q) = (P\<lbrakk>false/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>false/x\<^sup><\<rbrakk>)"
  using assms by (rel_auto, metis (full_types) vwb_lens_wb wb_lens.get_put)

lemma seqr_right_one_point_true:
  assumes "vwb_lens x"
  shows "(P ;; (($x\<^sup><)\<^sub>u \<and> Q)) = (P\<lbrakk>true/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>true/x\<^sup><\<rbrakk>)"
  using assms by (rel_auto, metis (full_types) vwb_lens_wb wb_lens.get_put)

lemma seqr_right_one_point_false:
  assumes "vwb_lens x"
  shows "(P ;; (\<not>($x\<^sup><)\<^sub>u \<and> Q)) = (P\<lbrakk>false/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>false/x\<^sup><\<rbrakk>)"
  using assms by (rel_auto, metis (full_types) vwb_lens_wb wb_lens.get_put)

lemma seqr_insert_ident_left:
  assumes "vwb_lens x" "$x\<^sup>> \<sharp> P" "$x\<^sup>< \<sharp> Q"
  shows "((($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> P) ;; Q) = (P ;; Q)"
  using assms by (rel_auto, meson vwb_lens_wb wb_lens_weak weak_lens.put_get)

lemma seqr_insert_ident_right:
  assumes "vwb_lens x" "$x\<^sup>> \<sharp> P" "$x\<^sup>< \<sharp> Q"
  shows "(P ;; (($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> Q)) = (P ;; Q)"
  using assms by (rel_auto, metis (no_types, hide_lams) vwb_lens_def wb_lens_def weak_lens.put_get)

lemma seq_var_ident_lift:
  assumes "vwb_lens x" "$x\<^sup>> \<sharp> P" "$x\<^sup>< \<sharp> Q"
  shows "((($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> P) ;; (($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> Q)) = (($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> (P ;; Q))"
  using assms by (rel_auto, metis (no_types, lifting) vwb_lens_wb wb_lens_weak weak_lens.put_get)

lemma seqr_bool_split:
  assumes "vwb_lens x"
  shows "P ;; Q = (P\<lbrakk>true/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>true/x\<^sup><\<rbrakk> \<or> P\<lbrakk>(false)\<^sub>u/x\<^sup>>\<rbrakk> ;; Q\<lbrakk>false/x\<^sup><\<rbrakk>)"
  using assms apply (subst seqr_middle[of x], simp_all)
   oops

lemma cond_inter_var_split:
  assumes "vwb_lens x"
  shows "(P \<lhd> $x\<^sup>> \<rhd> Q) ;; R = (P\<lbrakk>true/x\<^sup>>\<rbrakk> ;; R\<lbrakk>true/x\<^sup><\<rbrakk> \<or> Q\<lbrakk>false/x\<^sup>>\<rbrakk> ;; R\<lbrakk>false/x\<^sup><\<rbrakk>)"
proof -
  have "(P \<lhd> $x\<^sup>> \<rhd> Q) ;; R = (((x\<^sup>>)\<^sub>u \<and> P) ;; R \<or> (\<not> (x\<^sup>>)\<^sub>u \<and> Q) ;; R)"
    by rel_simp
  also have "... = ((P \<and> (x\<^sup>>)\<^sub>u) ;; R \<or> (Q \<and> \<not>(x\<^sup>>)\<^sub>u) ;; R)"
    by (rel_auto)
  also have "... = (P\<lbrakk>true/x\<^sup>>\<rbrakk> ;; R\<lbrakk>true/x\<^sup><\<rbrakk> \<or> Q\<lbrakk>false/x\<^sup>>\<rbrakk> ;; R\<lbrakk>false/x\<^sup><\<rbrakk>)"
    apply (rel_auto add: seqr_left_one_point_true seqr_left_one_point_false assms)
    by (metis (full_types) assms vwb_lens_wb wb_lens.get_put)+
  finally show ?thesis .
qed

theorem seqr_pre_transfer: "in\<alpha> \<sharp> q \<Longrightarrow> ((P \<and> q) ;; R) = (P ;; (q\<^sup>- \<and> R))"
  by rel_auto

theorem seqr_pre_transfer':
  "((P \<and> (q\<^sup>>)\<^sub>u) ;; R) = (P ;; ((q\<^sup><)\<^sub>u \<and> R))"
  by (rel_auto)

theorem seqr_post_out: "in\<alpha> \<sharp> r \<Longrightarrow> (P ;; (Q \<and> r)) = ((P ;; Q) \<and> r)"
  by (rel_auto)

lemma seqr_post_var_out:
  shows "(P ;; (Q \<and> (x\<^sup>>)\<^sub>u)) = ((P ;; Q) \<and> (x\<^sup>>)\<^sub>u)"
  by (rel_auto)

theorem seqr_post_transfer: "out\<alpha> \<sharp> q \<Longrightarrow> (P ;; (q \<and> R)) = ((P \<and> q\<^sup>-) ;; R)"
  by (rel_auto)

lemma seqr_pre_out: "out\<alpha> \<sharp> p \<Longrightarrow> ((p \<and> Q) ;; R) = (p \<and> (Q ;; R))"
  by (rel_auto)

lemma seqr_pre_var_out:
  shows "(((x\<^sup><)\<^sub>u \<and> P) ;; Q) = ((x\<^sup><)\<^sub>u \<and> (P ;; Q))"
  by (rel_auto)

lemma seqr_true_lemma:
  "(P = (\<not> ((\<not> P) ;; true))) = (P = (P ;; true))"
  by (rel_auto)

lemma seqr_to_conj: "\<lbrakk> out\<alpha> \<sharp> P; in\<alpha> \<sharp> Q \<rbrakk> \<Longrightarrow> (P ;; Q) = (P \<and> Q)"
  by (rel_auto; blast)

lemma liberate_seq_unfold:
  "x \<sharp> Q \<Longrightarrow> (P \\ x) ;; Q = (P ;; Q) \\ x"
  apply (rel_simp add: liberate_pred_def)
  oops

(*
lemma shEx_mem_lift_seq_1 [uquant_lift]:
  assumes "out\<alpha> \<sharp> A"
  shows "((\<^bold>\<exists> x \<in> A \<bullet> P x) ;; Q) = (\<^bold>\<exists> x \<in> A \<bullet> (P x ;; Q))"
  using assms by rel_blast

lemma shEx_lift_seq_2 [uquant_lift]:
  "(P ;; (\<^bold>\<exists> x \<bullet> Q x)) = (\<^bold>\<exists> x \<bullet> (P ;; Q x))"
  by rel_auto

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

lemma seq_Sup_distl: "P ;; (\<Union> A) = (\<Union> Q\<in>A. P ;; Q)"
  by (transfer, auto)

lemma seq_Sup_distr: "(\<Union> A) ;; Q = (\<Union> P\<in>A. P ;; Q)"
  by (transfer, auto)

lemma seq_UINF_distl: "P ;; (\<Union> Q\<in>A. F(Q)) = (\<Union> Q\<in>A. P ;; F(Q))"
  by auto

lemma seq_UINF_distl': "P ;; (\<Union> Q. F(Q)) = (\<Union> Q. P ;; F(Q))"
  by (metis seq_UINF_distl)

lemma seq_UINF_distr: "(\<Union> P\<in>A . F(P)) ;; Q = (\<Union> P\<in>A. F(P) ;; Q)"
  by auto

lemma seq_UINF_distr': "(\<Union> P. F(P)) ;; Q = (\<Union> P. F(P) ;; Q)"
  by (metis seq_UINF_distr)

lemma seq_SUP_distl: "P ;; (\<Union>i\<in>A. Q(i)) = (\<Union>i\<in>A. P ;; Q(i))"
  by (metis image_image seq_Sup_distl)

lemma seq_SUP_distr: "(\<Union>i\<in>A. P(i)) ;; Q = (\<Union>i\<in>A. P(i) ;; Q)"
  by (simp add: seq_Sup_distr)

subsection \<open> Skip Laws \<close>
    
lemma cond_skip: "out\<alpha> \<sharp> b \<Longrightarrow> (b \<and> II) = (II \<and> b\<^sup>-)"
  by (rel_auto)

lemma pre_skip_post: "((b\<^sup><)\<^sub>u \<and> II) = (II \<and> (b\<^sup>>)\<^sub>u)"
  by (rel_auto)

lemma skip_var:
  fixes x :: "(bool \<Longrightarrow> '\<alpha>)"
  shows "(($x\<^sup><)\<^sub>u \<and> II) = (II \<and> ($x\<^sup>>)\<^sub>u)"
  by (rel_auto)

(*
text \<open>Liberate currently doesn't work on relations - it expects a lens of type 'a instead of 'a \<times> 'a\<close>
lemma skip_r_unfold:
  "vwb_lens x \<Longrightarrow> II = (($x\<^sup>> = $x\<^sup><)\<^sub>u \<and> II \\ $x)"
  by (rel_simp, metis mwb_lens.put_put vwb_lens_mwb vwb_lens_wb wb_lens.get_put)
*)

lemma skip_r_alpha_eq:
  "II = (\<^bold>v\<^sup>< = \<^bold>v\<^sup>>)\<^sub>u"
  by (rel_auto)

(*
lemma skip_ra_unfold:
  "II\<^bsub>x;y\<^esub> = ($x\<acute> =\<^sub>u $x \<and> II\<^bsub>y\<^esub>)"
  by (rel_auto)

lemma skip_res_as_ra:
  "\<lbrakk> vwb_lens y; x +\<^sub>L y \<approx>\<^sub>L 1\<^sub>L; x \<bowtie> y \<rbrakk> \<Longrightarrow> II\<restriction>\<^sub>\<alpha>x = II\<^bsub>y\<^esub>"
  apply (rel_auto)
   apply (metis (no_types, lifting) lens_indep_def)
  apply (metis vwb_lens.put_eq)
  done
*)
subsection \<open> Assignment Laws \<close>
  
lemma assigns_subst [usubst]:
  "\<lceil>\<sigma>\<rceil>\<^sub>s \<dagger> \<langle>\<rho>\<rangle>\<^sub>a = \<langle>\<rho> \<circ>\<^sub>s \<sigma>\<rangle>\<^sub>a"
  by (rel_auto)

lemma assigns_r_comp: "(\<langle>\<sigma>\<rangle>\<^sub>a ;; P) = (\<lceil>\<sigma>\<rceil>\<^sub>s \<dagger> P)"
  by (rel_auto)

lemma assigns_r_feasible:
  "(\<langle>\<sigma>\<rangle>\<^sub>a ;; true) = true"
  by (rel_auto)

lemma assign_subst [usubst]:
  "\<lbrakk> mwb_lens x; mwb_lens y \<rbrakk> \<Longrightarrow> [$x \<mapsto>\<^sub>s \<lceil>u\<rceil>\<^sub><] \<dagger> (y := v) = (x, y) := (u, [x \<mapsto>\<^sub>s u] \<dagger> v)"
  by (rel_auto)

lemma assign_vacuous_skip:
  assumes "vwb_lens x"
  shows "(x := $x) = II"
  using assms by rel_auto

text \<open> The following law shows the case for the above law when $x$ is only mainly-well behaved. We
  require that the state is one of those in which $x$ is well defined using and assumption. \<close>

lemma assign_vacuous_assume:
  assumes "mwb_lens x"
  shows "[&\<^bold>v \<in> \<guillemotleft>\<S>\<^bsub>x\<^esub>\<guillemotright>]\<^sup>\<top> ;; (x := &x) = [&\<^bold>v \<in> \<guillemotleft>\<S>\<^bsub>x\<^esub>\<guillemotright>]\<^sup>\<top>"
  using assms by rel_auto

lemma assign_simultaneous:
  assumes "vwb_lens y" "x \<bowtie> y"
  shows "(x,y) := (e, &y) = (x := e)"
  by (simp add: assms usubst_upd_comm usubst_upd_var_id)

lemma assigns_idem: "mwb_lens x \<Longrightarrow> (x,x) := (u,v) = (x := v)"
  apply rel_auto oops

lemma assigns_cond: "(\<langle>f\<rangle>\<^sub>a \<triangleleft> b \<triangleright>\<^sub>r \<langle>g\<rangle>\<^sub>a) = \<langle>f \<triangleleft> b \<triangleright> g\<rangle>\<^sub>a"
  by (rel_auto)

lemma assigns_r_conv:
  "bij\<^sub>s f \<Longrightarrow> \<langle>f\<rangle>\<^sub>a\<^sup>- = \<langle>inv\<^sub>s f\<rangle>\<^sub>a"
  by (rel_auto, simp_all add: bij_is_inj bij_is_surj surj_f_inv_f)

lemma assign_pred_transfer:
  fixes x :: "('a \<Longrightarrow> '\<alpha>)"
  assumes "$x \<sharp> b" "out\<alpha> \<sharp> b"
  shows "(b \<and> x := v) = (x := v \<and> b\<^sup>-)"
  using assms by (rel_blast)
    
lemma assign_r_comp: "x := u ;; P = P\<lbrakk>u\<^sup></x\<^sup><\<rbrakk>"
  by rel_auto

lemma assign_test: "mwb_lens x \<Longrightarrow> (x := \<guillemotleft>u\<guillemotright> ;; x := \<guillemotleft>v\<guillemotright>) = (x := \<guillemotleft>v\<guillemotright>)"
  by rel_auto

lemma assign_twice: "\<lbrakk> mwb_lens x; $x \<sharp> f \<rbrakk> \<Longrightarrow> (x := e ;; x := f) = (x := f)"
  by rel_auto
 
lemma assign_commute:
  assumes "$x \<bowtie> $y" "$x \<sharp> f" "$y \<sharp> e"
  shows "(x := e ;; y := f) = (y := f ;; x := e)"
  using assms
  apply (rel_auto) oops

lemma assign_cond:
  fixes x :: "('a \<Longrightarrow> '\<alpha>)"
  assumes "out\<alpha> \<sharp> b"
  shows "(x := e ;; (P \<triangleleft> b \<triangleright> Q)) = ((x := e ;; P) \<triangleleft> (b\<lbrakk>\<lceil>e\<rceil>\<^sub></$x\<rbrakk>) \<triangleright> (x := e ;; Q))"
  by (rel_auto)

lemma assign_rcond:
  fixes x :: "('a \<Longrightarrow> '\<alpha>)"
  shows "(x := e ;; (P \<triangleleft> b \<triangleright>\<^sub>r Q)) = ((x := e ;; P) \<triangleleft> (b\<lbrakk>e/x\<rbrakk>) \<triangleright>\<^sub>r (x := e ;; Q))"
  by (rel_auto)

lemma assign_r_alt_def:
  fixes x :: "('a \<Longrightarrow> '\<alpha>)"
  shows "x := v = II\<lbrakk>\<lceil>v\<rceil>\<^sub></$x\<rbrakk>"
  by (rel_auto)

(*lemma assigns_r_ufunc: "ufunctional \<langle>f\<rangle>\<^sub>a"
  by (rel_auto)

lemma assigns_r_uinj: "inj\<^sub>s f \<Longrightarrow> uinj \<langle>f\<rangle>\<^sub>a"
  apply (rel_simp, simp add: inj_eq) *)
    
lemma assigns_r_swap_uinj:
  "\<lbrakk> vwb_lens x; vwb_lens y; x \<bowtie> y \<rbrakk> \<Longrightarrow> uinj ((x,y) := (&y,&x))"
  by (metis assigns_r_uinj pr_var_def swap_usubst_inj)

lemma assign_unfold:
  "vwb_lens x \<Longrightarrow> (x := v) = ($x\<acute> =\<^sub>u \<lceil>v\<rceil>\<^sub>< \<and> II\<restriction>\<^sub>\<alpha>x)"
  apply (rel_auto, auto simp add: comp_def)
  using vwb_lens.put_eq by fastforce

subsection \<open> Non-deterministic Assignment Laws \<close>

lemma nd_assign_comp:
  "x \<bowtie> y \<Longrightarrow> x := * ;; y := * = x,y := *"
  apply (rel_auto) using lens_indep_comm by fastforce+

lemma nd_assign_assign:
  "\<lbrakk> vwb_lens x; x \<sharp> e \<rbrakk> \<Longrightarrow> x := * ;; x := e = x := e"
  by (rel_auto)

subsection \<open> Converse Laws \<close>

lemma convr_invol [simp]: "p\<^sup>-\<^sup>- = p"
  by pred_auto

lemma lit_convr [simp]: "\<guillemotleft>v\<guillemotright>\<^sup>- = \<guillemotleft>v\<guillemotright>"
  by pred_auto

lemma uivar_convr [simp]:
  fixes x :: "('a \<Longrightarrow> '\<alpha>)"
  shows "($x)\<^sup>- = $x\<acute>"
  by pred_auto

lemma uovar_convr [simp]:
  fixes x :: "('a \<Longrightarrow> '\<alpha>)"
  shows "($x\<acute>)\<^sup>- = $x"
  by pred_auto

lemma uop_convr [simp]: "(uop f u)\<^sup>- = uop f (u\<^sup>-)"
  by (pred_auto)

lemma bop_convr [simp]: "(bop f u v)\<^sup>- = bop f (u\<^sup>-) (v\<^sup>-)"
  by (pred_auto)

lemma eq_convr [simp]: "(p =\<^sub>u q)\<^sup>- = (p\<^sup>- =\<^sub>u q\<^sup>-)"
  by (pred_auto)

lemma not_convr [simp]: "(\<not> p)\<^sup>- = (\<not> p\<^sup>-)"
  by (pred_auto)

lemma disj_convr [simp]: "(p \<or> q)\<^sup>- = (q\<^sup>- \<or> p\<^sup>-)"
  by (pred_auto)

lemma conj_convr [simp]: "(p \<and> q)\<^sup>- = (q\<^sup>- \<and> p\<^sup>-)"
  by (pred_auto)

lemma seqr_convr [simp]: "(p ;; q)\<^sup>- = (q\<^sup>- ;; p\<^sup>-)"
  by (rel_auto)

lemma pre_convr [simp]: "\<lceil>p\<rceil>\<^sub><\<^sup>- = \<lceil>p\<rceil>\<^sub>>"
  by (rel_auto)

lemma post_convr [simp]: "\<lceil>p\<rceil>\<^sub>>\<^sup>- = \<lceil>p\<rceil>\<^sub><"
  by (rel_auto)

subsection \<open> Assertion and Assumption Laws \<close>

declare sublens_def [lens_defs del]
  
lemma assume_false: "[false]\<^sup>\<top> = false"
  by (rel_auto)
  
lemma assume_true: "[true]\<^sup>\<top> = II"
  by (rel_auto)
    
lemma assume_seq: "[b]\<^sup>\<top> ;; [c]\<^sup>\<top> = [(b \<and> c)]\<^sup>\<top>"
  by (rel_auto)

lemma assert_false: "{false}\<^sub>\<bottom> = true"
  by (rel_auto)

lemma assert_true: "{true}\<^sub>\<bottom> = II"
  by (rel_auto)
    
lemma assert_seq: "{b}\<^sub>\<bottom> ;; {c}\<^sub>\<bottom> = {(b \<and> c)}\<^sub>\<bottom>"
  by (rel_auto)

subsection \<open> While Loop Laws \<close>

theorem while_unfold:
  "while b do P od = ((P ;; while b do P od) \<Zdres> b \<Zrres> II)"
proof -
  have m:"mono (\<lambda>X. (P ;; X) \<triangleleft> b \<triangleright>\<^sub>r II)"
    by (auto intro: monoI seqr_mono cond_mono)
  have "(while b do P od) = (\<nu> X \<bullet> (P ;; X) \<triangleleft> b \<triangleright>\<^sub>r II)"
    by (simp add: while_top_def)
  also have "... = ((P ;; (\<nu> X \<bullet> (P ;; X) \<triangleleft> b \<triangleright>\<^sub>r II)) \<triangleleft> b \<triangleright>\<^sub>r II)"
    by (subst lfp_unfold, simp_all add: m)
  also have "... = ((P ;; while b do P od) \<triangleleft> b \<triangleright>\<^sub>r II)"
    by (simp add: while_top_def)
  finally show ?thesis .
qed

theorem while_false: "while (false)\<^sub>e do P od = II"
  by (subst while_unfold, rel_auto)

theorem while_true: "while true do P od = false"
  apply (simp add: while_top_def alpha)
  apply (rule antisym)
   apply (simp_all)
  apply (rule lfp_lowerbound)
  apply (rel_auto)
  done

theorem while_bot_unfold:
  "while\<^sub>\<bottom> b do P od = ((P ;; while\<^sub>\<bottom> b do P od) \<triangleleft> b \<triangleright>\<^sub>r II)"
proof -
  have m:"mono (\<lambda>X. (P ;; X) \<triangleleft> b \<triangleright>\<^sub>r II)"
    by (auto intro: monoI seqr_mono cond_mono)
  have "(while\<^sub>\<bottom> b do P od) = (\<mu> X \<bullet> (P ;; X) \<triangleleft> b \<triangleright>\<^sub>r II)"
    by (simp add: while_bot_def)
  also have "... = ((P ;; (\<mu> X \<bullet> (P ;; X) \<triangleleft> b \<triangleright>\<^sub>r II)) \<triangleleft> b \<triangleright>\<^sub>r II)"
    by (subst gfp_unfold, simp_all add: m)
  also have "... = ((P ;; while\<^sub>\<bottom> b do P od) \<triangleleft> b \<triangleright>\<^sub>r II)"
    by (simp add: while_bot_def)
  finally show ?thesis .
qed

theorem while_bot_false: "while\<^sub>\<bottom> false do P od = II"
  by (simp add: while_bot_def mu_const alpha)

theorem while_bot_true: "while\<^sub>\<bottom> true do P od = (\<mu> X \<bullet> P ;; X)"
  by (simp add: while_bot_def alpha)

text \<open> An infinite loop with a feasible body corresponds to a program error (non-termination). \<close>

theorem while_infinite: "P ;; true\<^sub>h = true \<Longrightarrow> while\<^sub>\<bottom> true do P od = true"
  apply (simp add: while_bot_true)
  apply (rule antisym)
   apply (simp)
  apply (rule gfp_upperbound)
  apply (simp)
  done

subsection \<open> Algebraic Properties \<close>

interpretation upred_semiring: semiring_1
  where times = seqr and one = skip_r and zero = false\<^sub>h and plus = Lattices.sup
  by (unfold_locales, (rel_auto)+)

declare upred_semiring.power_Suc [simp del]

text \<open> We introduce the power syntax derived from semirings \<close>

abbreviation upower :: "'\<alpha> hrel \<Rightarrow> nat \<Rightarrow> '\<alpha> hrel" (infixr "\<^bold>^" 80) where
"upower P n \<equiv> upred_semiring.power P n"

translations
  "P \<^bold>^ i" <= "CONST power.power II op ;; P i"
  "P \<^bold>^ i" <= "(CONST power.power II op ;; P) i"

text \<open> Set up transfer tactic for powers \<close>

lemma upower_rep_eq:
  "\<lbrakk>P \<^bold>^ i\<rbrakk>\<^sub>e = (\<lambda> b. b \<in> ({p. \<lbrakk>P\<rbrakk>\<^sub>e p} ^^ i))"
proof (induct i arbitrary: P)
  case 0
  then show ?case
    by (auto, rel_auto)
next
  case (Suc i)
  show ?case
    by (simp add: Suc seqr.rep_eq relpow_commute upred_semiring.power_Suc)
qed

lemma upower_rep_eq_alt:
  "\<lbrakk>power.power \<langle>id\<^sub>s\<rangle>\<^sub>a (;;) P i\<rbrakk>\<^sub>e = (\<lambda>b. b \<in> ({p. \<lbrakk>P\<rbrakk>\<^sub>e p} ^^ i))"
  by (metis skip_r_def upower_rep_eq)

update_uexpr_rep_eq_thms
  
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
    by (simp add: atLeast_Suc_greaterThan greaterThan_0)
  ultimately show ?thesis
    by (simp only:)
qed

lemma Sup_upto_Suc: "(\<Sqinter>i\<in>{0..Suc n}. P \<^bold>^ i) = (\<Sqinter>i\<in>{0..n}. P \<^bold>^ i) \<sqinter> P \<^bold>^ Suc n"
proof -
  have "(\<Sqinter>i\<in>{0..Suc n}. P \<^bold>^ i) = (\<Sqinter>i\<in>insert (Suc n) {0..n}. P \<^bold>^ i)"
    by (simp add: atLeast0_atMost_Suc)
  also have "... = P \<^bold>^ Suc n \<sqinter> (\<Sqinter>i\<in>{0..n}. P \<^bold>^ i)"
    by (simp)
  finally show ?thesis
    by (simp add: Lattices.sup_commute)
qed

text \<open> The following two proofs are adapted from the AFP entry 
  \href{https://www.isa-afp.org/entries/Kleene_Algebra.shtml}{Kleene Algebra}. 
  See also~\cite{Armstrong2012,Armstrong2015}. \<close>

lemma upower_inductl: "Q \<sqsubseteq> ((P ;; Q) \<sqinter> R) \<Longrightarrow> Q \<sqsubseteq> P \<^bold>^ n ;; R"
proof (induct n)
  case 0
  then show ?case by (auto)
next
  case (Suc n)
  then show ?case
    by (auto simp add: upred_semiring.power_Suc, metis (no_types, hide_lams) dual_order.trans order_refl seqr_assoc seqr_mono)
qed

lemma upower_inductr:
  assumes "Q \<sqsubseteq> R \<sqinter> (Q ;; P)"
  shows "Q \<sqsubseteq> R ;; (P \<^bold>^ n)"
using assms proof (induct n)
  case 0
  then show ?case by auto
next
  case (Suc n)
  have "R ;; P \<^bold>^ Suc n = (R ;; P \<^bold>^ n) ;; P"
    by (metis seqr_assoc upred_semiring.power_Suc2)
  also have "Q ;; P \<sqsubseteq> ..."
    by (meson Suc.hyps assms eq_iff seqr_mono)
  also have "Q \<sqsubseteq> ..."
    using assms by auto
  finally show ?case .
qed

lemma SUP_atLeastAtMost_first:
  fixes P :: "nat \<Rightarrow> 'a::complete_lattice"
  assumes "m \<le> n"
  shows "(\<Sqinter>i\<in>{m..n}. P(i)) = P(m) \<sqinter> (\<Sqinter>i\<in>{Suc m..n}. P(i))"
  by (metis SUP_insert assms atLeastAtMost_insertL)
    
lemma upower_seqr_iter: "P \<^bold>^ n = (;; Q : replicate n P \<bullet> Q)"
  by (induct n, simp_all add: upred_semiring.power_Suc)

lemma assigns_power: "\<langle>f\<rangle>\<^sub>a \<^bold>^ n = \<langle>f ^\<^sub>s n\<rangle>\<^sub>a"
  by (induct n, rel_auto+)

subsection \<open> Kleene Star \<close>

definition ustar :: "'\<alpha> hrel \<Rightarrow> '\<alpha> hrel" ("_\<^sup>\<star>" [999] 999) where
"P\<^sup>\<star> = (\<Sqinter>i\<in>{0..} \<bullet> P\<^bold>^i)"

lemma ustar_rep_eq:
  "\<lbrakk>P\<^sup>\<star>\<rbrakk>\<^sub>e = (\<lambda>b. b \<in> ({p. \<lbrakk>P\<rbrakk>\<^sub>e p}\<^sup>*))"
  by (simp add: ustar_def, rel_auto, simp_all add: relpow_imp_rtrancl rtrancl_imp_relpow)

update_uexpr_rep_eq_thms

subsection \<open> Kleene Plus \<close>

purge_notation trancl ("(_\<^sup>+)" [1000] 999)

definition uplus :: "'\<alpha> hrel \<Rightarrow> '\<alpha> hrel" ("_\<^sup>+" [999] 999) where
[upred_defs]: "P\<^sup>+ = P ;; P\<^sup>\<star>"

lemma uplus_power_def: "P\<^sup>+ = (\<Sqinter> i \<bullet> P \<^bold>^ (Suc i))"
  by (simp add: uplus_def ustar_def seq_UINF_distl' UINF_atLeast_Suc upred_semiring.power_Suc)

subsection \<open> Omega \<close>

definition uomega :: "'\<alpha> hrel \<Rightarrow> '\<alpha> hrel" ("_\<^sup>\<omega>" [999] 999) where
"P\<^sup>\<omega> = (\<mu> X \<bullet> P ;; X)"

subsection \<open> Relation Algebra Laws \<close>

theorem RA1: "(P ;; (Q ;; R)) = ((P ;; Q) ;; R)"
  by (simp add: seqr_assoc)

theorem RA2: "(P ;; II) = P" "(II ;; P) = P"
  by simp_all

theorem RA3: "P\<^sup>-\<^sup>- = P"
  by simp

theorem RA4: "(P ;; Q)\<^sup>- = (Q\<^sup>- ;; P\<^sup>-)"
  by simp

theorem RA5: "(P \<or> Q)\<^sup>- = (P\<^sup>- \<or> Q\<^sup>-)"
  by (rel_auto)

theorem RA6: "((P \<or> Q) ;; R) = (P;;R \<or> Q;;R)"
  using seqr_or_distl by blast

theorem RA7: "((P\<^sup>- ;; (\<not>(P ;; Q))) \<or> (\<not>Q)) = (\<not>Q)"
  by (rel_auto)

subsection \<open> Kleene Algebra Laws \<close>

lemma ustar_alt_def: "P\<^sup>\<star> = (\<Sqinter> i \<bullet> P \<^bold>^ i)"
  by (simp add: ustar_def)

theorem ustar_sub_unfoldl: "P\<^sup>\<star> \<sqsubseteq> II \<sqinter> (P;;P\<^sup>\<star>)"
  by (rel_simp, simp add: rtrancl_into_trancl2 trancl_into_rtrancl)
    
theorem ustar_inductl:
  assumes "Q \<sqsubseteq> R" "Q \<sqsubseteq> P ;; Q"
  shows "Q \<sqsubseteq> P\<^sup>\<star> ;; R"
proof -
  have "P\<^sup>\<star> ;; R = (\<Sqinter> i. P \<^bold>^ i ;; R)"
    by (simp add: ustar_def UINF_as_Sup_collect' seq_SUP_distr)
  also have "Q \<sqsubseteq> ..."
    by (simp add: SUP_least assms upower_inductl)
  finally show ?thesis .
qed

theorem ustar_inductr:
  assumes "Q \<sqsubseteq> R" "Q \<sqsubseteq> Q ;; P"
  shows "Q \<sqsubseteq> R ;; P\<^sup>\<star>"
proof -
  have "R ;; P\<^sup>\<star> = (\<Sqinter> i. R ;; P \<^bold>^ i)"
    by (simp add: ustar_def UINF_as_Sup_collect' seq_SUP_distl)
  also have "Q \<sqsubseteq> ..."
    by (simp add: SUP_least assms upower_inductr)
  finally show ?thesis .
qed

lemma ustar_refines_nu: "(\<nu> X \<bullet> (P ;; X) \<sqinter> II) \<sqsubseteq> P\<^sup>\<star>"
  by (metis (no_types, lifting) lfp_greatest semilattice_sup_class.le_sup_iff 
      semilattice_sup_class.sup_idem upred_semiring.mult_2_right 
      upred_semiring.one_add_one ustar_inductl)

lemma ustar_as_nu: "P\<^sup>\<star> = (\<nu> X \<bullet> (P ;; X) \<sqinter> II)"
proof (rule antisym)
  show "(\<nu> X \<bullet> (P ;; X) \<sqinter> II) \<sqsubseteq> P\<^sup>\<star>"
    by (simp add: ustar_refines_nu)
  show "P\<^sup>\<star> \<sqsubseteq> (\<nu> X \<bullet> (P ;; X) \<sqinter> II)"
    by (metis lfp_lowerbound upred_semiring.add_commute ustar_sub_unfoldl)
qed

lemma ustar_unfoldl: "P\<^sup>\<star> = II \<sqinter> (P ;; P\<^sup>\<star>)"
  apply (simp add: ustar_as_nu)
  apply (subst lfp_unfold)
   apply (rule monoI)
   apply (rel_auto)+
  done

text \<open> While loop can be expressed using Kleene star \<close>

lemma while_star_form:
  "while b do P od = (P \<triangleleft> b \<triangleright>\<^sub>r II)\<^sup>\<star> ;; [(\<not>b)]\<^sup>\<top>"
proof -
  have 1: "Continuous (\<lambda>X. P ;; X \<triangleleft> b \<triangleright>\<^sub>r II)"
    by (rel_auto)
  have "while b do P od = (\<Sqinter>i. ((\<lambda>X. P ;; X \<triangleleft> b \<triangleright>\<^sub>r II) ^^ i) false)"
    by (simp add: "1" false_upred_def sup_continuous_Continuous sup_continuous_lfp while_top_def)
  also have "... = ((\<lambda>X. P ;; X \<triangleleft> b \<triangleright>\<^sub>r II) ^^ 0) false \<sqinter> (\<Sqinter>i. ((\<lambda>X. P ;; X \<triangleleft> b \<triangleright>\<^sub>r II) ^^ (i+1)) false)"
    by (subst Sup_power_expand, simp)
  also have "... = (\<Sqinter>i. ((\<lambda>X. P ;; X \<triangleleft> b \<triangleright>\<^sub>r II) ^^ (i+1)) false)"
    by (simp)
  also have "... = (\<Sqinter>i. (P \<triangleleft> b \<triangleright>\<^sub>r II)\<^bold>^i ;; (false \<triangleleft> b \<triangleright>\<^sub>r II))"
  proof (rule SUP_cong, simp_all)
    fix i
    show "P ;; ((\<lambda>X. P ;; X \<triangleleft> b \<triangleright>\<^sub>r II) ^^ i) false \<triangleleft> b \<triangleright>\<^sub>r II = (P \<triangleleft> b \<triangleright>\<^sub>r II) \<^bold>^ i ;; (false \<triangleleft> b \<triangleright>\<^sub>r II)"
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
  also have "... = (\<Sqinter>i\<in>{0..} \<bullet> (P \<triangleleft> b \<triangleright>\<^sub>r II)\<^bold>^i ;; [(\<not>b)]\<^sup>\<top>)"
    by (rel_auto)
  also have "... = (P \<triangleleft> b \<triangleright>\<^sub>r II)\<^sup>\<star> ;; [(\<not>b)]\<^sup>\<top>"
    by (metis seq_UINF_distr ustar_def)
  finally show ?thesis .
qed
  
subsection \<open> Omega Algebra Laws \<close>

lemma uomega_induct:
  "P ;; P\<^sup>\<omega> \<sqsubseteq> P\<^sup>\<omega>"
  by (simp add: uomega_def, metis eq_refl gfp_unfold monoI seqr_mono)

subsection \<open> Refinement Laws \<close>

lemma skip_r_refine:
  "(p \<Rightarrow> p) \<sqsubseteq> II"
  by pred_blast

lemma conj_refine_left:
  "(Q \<Rightarrow> P) \<sqsubseteq> R \<Longrightarrow> P \<sqsubseteq> (Q \<and> R)"
  by (rel_auto)
  
lemma pre_weak_rel:
  assumes "`pre \<Rightarrow> I`"
  and     "(I \<Rightarrow> post) \<sqsubseteq> P"
  shows "(pre \<Rightarrow> post) \<sqsubseteq> P"
  using assms by(rel_auto)
    
lemma cond_refine_rel: 
  assumes "S \<sqsubseteq> (\<lceil>b\<rceil>\<^sub>< \<and> P)" "S \<sqsubseteq> (\<lceil>\<not>b\<rceil>\<^sub>< \<and> Q)"
  shows "S \<sqsubseteq> P \<triangleleft> b \<triangleright>\<^sub>r Q"
  by (metis aext_not assms(1) assms(2) cond_def lift_rcond_def utp_pred_laws.le_sup_iff)

lemma seq_refine_pred:
  assumes "(\<lceil>b\<rceil>\<^sub>< \<Rightarrow> \<lceil>s\<rceil>\<^sub>>) \<sqsubseteq> P" and "(\<lceil>s\<rceil>\<^sub>< \<Rightarrow> \<lceil>c\<rceil>\<^sub>>) \<sqsubseteq> Q"
  shows "(\<lceil>b\<rceil>\<^sub>< \<Rightarrow> \<lceil>c\<rceil>\<^sub>>) \<sqsubseteq> (P ;; Q)"
  using assms by rel_auto
    
lemma seq_refine_unrest:
  assumes "out\<alpha> \<sharp> b" "in\<alpha> \<sharp> c"
  assumes "(b \<Rightarrow> \<lceil>s\<rceil>\<^sub>>) \<sqsubseteq> P" and "(\<lceil>s\<rceil>\<^sub>< \<Rightarrow> c) \<sqsubseteq> Q"
  shows "(b \<Rightarrow> c) \<sqsubseteq> (P ;; Q)"
  using assms by rel_blast 
    
subsection \<open> Preain and Postge Laws \<close>

named_theorems prepost

lemma Pre_conv_Post [prepost]:
  "Pre(P\<^sup>-) = Post(P)"
  by (rel_auto)

lemma Post_conv_Pre [prepost]:
  "Post(P\<^sup>-) = Pre(P)"
  by (rel_auto)  

lemma Pre_skip [prepost]:
  "Pre(II) = true"
  by (rel_auto)

lemma Pre_assigns [prepost]:
  "Pre(\<langle>\<sigma>\<rangle>\<^sub>a) = true"
  by (rel_auto)
   
lemma Pre_miracle [prepost]:
  "Pre(false) = false"
  by (rel_auto)

lemma Pre_assume [prepost]:
  "Pre([b]\<^sup>\<top>) = b"
  by (rel_auto)
    
lemma Pre_seq:
  "Pre(P ;; Q) = Pre(P ;; [Pre(Q)]\<^sup>\<top>)"
  by (rel_auto)
    
lemma Pre_disj [prepost]:
  "Pre(P \<or> Q) = (Pre(P) \<or> Pre(Q))"
  by (rel_auto)

lemma Pre_inf [prepost]:
  "Pre(P \<sqinter> Q) = (Pre(P) \<or> Pre(Q))"
  by (rel_auto)

text \<open> If P uses on the variables in @{term a} and @{term Q} does not refer to the variables of
  @{term "$a\<acute>"} then we can distribute. \<close>

lemma Pre_conj_indep [prepost]: "\<lbrakk> {$a,$a\<acute>} \<natural> P; $a\<acute> \<sharp> Q; vwb_lens a \<rbrakk> \<Longrightarrow> Pre(P \<and> Q) = (Pre(P) \<and> Pre(Q))"
  by (rel_auto, metis lens_override_def lens_override_idem)

lemma assume_Pre [prepost]:
  "[Pre(P)]\<^sup>\<top> ;; P = P"
  by (rel_auto)

end
