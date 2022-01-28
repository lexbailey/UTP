subsection \<open> UTP Relations \<close>

theory utp_rel
  imports utp_alpha utp_healthy utp_pred_laws
begin

consts
  uassigns :: "('a, 'b) psubst \<Rightarrow> 'c" ("\<langle>_\<rangle>\<^sub>a")
  uskip    :: "'a" ("II")

named_theorems rel and rel_transfer

type_synonym ('s\<^sub>1, 's\<^sub>2) rpred = "('s\<^sub>1 \<times> 's\<^sub>2) pred"

lemma rel_eq_iff [rel_transfer]: "P = Q \<longleftrightarrow> (\<forall> s s'. \<lbrakk>P\<rbrakk>\<^sub>P (s, s') = \<lbrakk>Q\<rbrakk>\<^sub>P (s, s'))"
  by (simp add: set_eq_iff set_pred_def)

lemma rel_unrest_ivar_iff [rel_transfer]: "vwb_lens x \<Longrightarrow> ($x\<^sup>< \<sharp> P) = (\<forall>(s, s')\<in>P. \<forall> v. (put\<^bsub>x\<^esub> s v, s') \<in> P)"
  by (simp add: unrest_var_pred, auto simp add: lens_defs prod.case_eq_if)

lemma rel_unrest_ovar_iff [rel_transfer]: "vwb_lens x \<Longrightarrow> ($x\<^sup>> \<sharp> P) = (\<forall>(s, s')\<in>P. \<forall> v. (s, put\<^bsub>x\<^esub> s' v) \<in> P)"
  by (simp add: unrest_var_pred, auto simp add: lens_defs prod.case_eq_if)

lemma in_rel_transfer: "(s, s') \<in> (P)\<^sub>u \<longleftrightarrow> P (s, s')"
  by (simp add: pred_set_def)

method rel_simp uses add = (simp add: add rel_transfer rel pred_core unrest)

text \<open> @{method rel_simp} simply desugars UTP notation, leaving a relational goal \<close>

method rel_auto uses add = (rel_simp add: add; (expr_simp add: add)?; (auto simp add: alpha_splits relcomp_unfold Id_on_iff add)?)

text \<open> @{method rel_auto} also explodes expressions and turns the relational goal into a predicative one \<close>

method rel_force uses add = (rel_simp add: add; (expr_simp add: add)?; (force simp add: alpha_splits relcomp_unfold Id_on_iff add)?)

subsection \<open> Operators \<close>

abbreviation "in\<alpha> \<equiv> var_alpha fst\<^sub>L"
abbreviation "out\<alpha> \<equiv> var_alpha snd\<^sub>L"

adhoc_overloading uskip Id

abbreviation "true\<^sub>h \<equiv> (true :: 's rel)"

definition cond :: "('s\<^sub>1 \<leftrightarrow> 's\<^sub>2) \<Rightarrow> ('s\<^sub>1 \<times> 's\<^sub>2 \<Rightarrow> bool) \<Rightarrow> ('s\<^sub>1 \<leftrightarrow> 's\<^sub>2) \<Rightarrow> ('s\<^sub>1 \<leftrightarrow> 's\<^sub>2)" where
[rel]: "cond P B Q = (((B)\<^sub>u \<and> P) \<or> ((\<not>B)\<^sub>u \<and> Q))" 

syntax 
  "_cond" :: "logic \<Rightarrow> logic \<Rightarrow> logic \<Rightarrow> logic" ("(3_ \<lhd> _ \<rhd>/ _)" [52,0,53] 52)
  "_rcond" :: "logic \<Rightarrow> logic \<Rightarrow> logic \<Rightarrow> logic" ("(3_ \<^bold>\<lhd> _ \<^bold>\<rhd>/ _)" [52,0,53] 52)

translations
  "_cond P B Q" == "CONST cond P (B)\<^sub>e Q"
  "_rcond P b Q" == "_cond P (b\<^sup><) Q"

abbreviation conv_r :: "('a \<leftrightarrow> 'b) \<Rightarrow> 'b \<leftrightarrow> 'a" ("_\<^sup>-" [999] 999) where
"conv_r p \<equiv> {(b,a). (a,b) \<in> p}"

definition assigns_rel :: "('s\<^sub>1, 's\<^sub>2) psubst \<Rightarrow> 's\<^sub>1 \<leftrightarrow> 's\<^sub>2" where
[rel]: "assigns_rel \<sigma> = pfun_graph (fun_pfun \<sigma>)"

adhoc_overloading uassigns assigns_rel

syntax "_assign" :: "svid \<Rightarrow> logic \<Rightarrow> logic" (infix ":=" 61)
translations "_assign x e" == "CONST uassigns [x \<leadsto> e]"

definition test :: "'s pred \<Rightarrow> 's rel" where
[rel]: "test P = Id_on (Collect P)"

syntax "_test" :: "logic \<Rightarrow> logic" ("\<questiondown>_?")
translations "\<questiondown>P?" == "CONST test (P)\<^sub>e"

definition ndet_assign :: "('a \<Longrightarrow> 's) \<Rightarrow> 's rel" where
[pred]: "ndet_assign x = (\<Union> v. x := \<guillemotleft>v\<guillemotright>)"

syntax "_ndet_assign" :: "svid \<Rightarrow> logic" ("_ := *" [75] 76)
translations "_ndet_assign x" == "CONST ndet_assign x"

definition seqr_iter :: "'a list \<Rightarrow> ('a \<Rightarrow> 'b rel) \<Rightarrow> 'b rel" where
[pred]: "seqr_iter xs P = foldr (\<lambda> i Q. P(i) \<Zcomp> Q) xs II"

syntax "_seqr_iter" :: "pttrn \<Rightarrow> 'a list \<Rightarrow> '\<sigma> rel \<Rightarrow> '\<sigma> rel" ("(3\<Zcomp> _ : _ \<bullet>/ _)" [0, 0, 10] 10)
translations "\<Zcomp> x : l \<bullet> P" \<rightleftharpoons> "(CONST seqr_iter) l (\<lambda>x. P)"

definition while_top :: "'s pred \<Rightarrow> 's rel \<Rightarrow> 's rel" ("while\<^sup>\<top> _ do _ od") where 
"while_top b P = (\<nu> X \<bullet> ((P \<Zcomp> X) \<^bold>\<lhd> b \<^bold>\<rhd> II))"

notation while_top ("while _ do _ od")

definition while_bot :: "'s pred \<Rightarrow> 's rel \<Rightarrow> 's rel" ("while\<^sub>\<bottom> _ do _ od") where 
"while_bot b P = (\<mu> X \<bullet> ((P \<Zcomp> X) \<^bold>\<lhd> b \<^bold>\<rhd> II))"

definition pre :: "('s\<^sub>1 \<leftrightarrow> 's\<^sub>2) \<Rightarrow> ('s\<^sub>1 \<Rightarrow> bool)" 
  where "pre P = \<lbrakk>Domain P\<rbrakk>\<^sub>P"

definition post :: "('s\<^sub>1 \<leftrightarrow> 's\<^sub>2) \<Rightarrow> ('s\<^sub>2 \<Rightarrow> bool)" 
  where "post P = \<lbrakk>Range P\<rbrakk>\<^sub>P"

definition frame :: "'s scene \<Rightarrow> 's rel \<Rightarrow> 's rel" where
"frame a P = {(s, s'). s \<approx>\<^sub>S s' on -a \<and> (s, s') \<in> P}"

text \<open> The frame extension operator take a lens @{term a}, and a relation @{term P}. It constructs
  a relation such that all variables outside of @{term a} are unchanged, and the valuations for
  @{term a} are drawn from @{term P}. Intuitively, this can be seen as extending the alphabet
  of @{term P}. \<close>

definition frame_ext :: "('s\<^sub>1 \<Longrightarrow> 's\<^sub>2) \<Rightarrow> 's\<^sub>1 rel \<Rightarrow> 's\<^sub>2 rel" where
  "frame_ext a P = frame \<lbrakk>a\<rbrakk>\<^sub>\<sim> (P \<up> (a \<times> a))"

syntax 
  "_frame" :: "salpha \<Rightarrow> logic \<Rightarrow> logic" ("_:[_]")
  "_frame_ext" :: "svid \<Rightarrow> logic \<Rightarrow> logic" ("_:[_]\<^sub>\<up>")

translations
  "_frame a P" == "CONST frame a P"
  "_frame_ext a P" == "CONST frame_ext a P"

text \<open> Promotion takes a partial lens @{term a} and a relation @{term P}. It constructs a relation
  that firstly restricts the state to valuations where @{term a} is valid (i.e. defined), and 
  secondly uses the lens to promote @{term P} so that it acts only on the @{term a} region of
  the state space. \<close>

definition promote :: "'c rel \<Rightarrow> ('c \<Longrightarrow> 's) \<Rightarrow> 's rel" where
[rel]: "promote P a = \<questiondown>\<^bold>D(a)? \<Zcomp> a:[P]\<^sub>\<up>"

syntax "_promote" :: "logic \<Rightarrow> svid \<Rightarrow> logic" (infix "\<Up>" 60)
translations "_promote P a" == "CONST promote P a"

subsection \<open> Predicate Semantics \<close>

lemma pred_skip [pred]: "\<lbrakk>II\<rbrakk>\<^sub>P = ($\<^bold>v\<^sup>> = $\<^bold>v\<^sup><)\<^sub>e"
  by expr_auto

lemma rel_skip [rel]: "\<lbrakk>II\<rbrakk>\<^sub>P (s, s') = (s = s')"
  by expr_auto

lemma rel_test [rel]: "\<lbrakk>\<questiondown>b?\<rbrakk>\<^sub>P (s, s') = (b s \<and> s = s')"
  by rel_auto

lemma pred_seq_hom [pred]:
  "\<lbrakk>P \<^bold>; Q\<rbrakk>\<^sub>P = (\<exists> v\<^sub>0. [ \<^bold>v\<^sup>> \<leadsto> \<guillemotleft>v\<^sub>0\<guillemotright> ] \<dagger> \<lbrakk>P\<rbrakk>\<^sub>P \<and> [ \<^bold>v\<^sup>< \<leadsto> \<guillemotleft>v\<^sub>0\<guillemotright> ] \<dagger> \<lbrakk>Q\<rbrakk>\<^sub>P)\<^sub>e"
  by (expr_auto)

lemma pred_seq [pred]: 
  "\<lbrakk>P \<^bold>; Q\<rbrakk>\<^sub>P = (\<exists> v\<^sub>0. \<lparr> \<^bold>v\<^sup>< \<leadsto> $\<^bold>v\<^sup><, \<^bold>v\<^sup>> \<leadsto> \<guillemotleft>v\<^sub>0\<guillemotright> \<rparr> \<dagger> \<lbrakk>P\<rbrakk>\<^sub>P \<and> \<lparr> \<^bold>v\<^sup>< \<leadsto> \<guillemotleft>v\<^sub>0\<guillemotright>, \<^bold>v\<^sup>> \<leadsto> $\<^bold>v\<^sup>> \<rparr> \<dagger> \<lbrakk>Q\<rbrakk>\<^sub>P)\<^sub>e"
  by (expr_auto)

lemma rel_seq [rel]: "\<lbrakk>P \<^bold>; Q\<rbrakk>\<^sub>P (s, s') = (\<exists> s\<^sub>0. \<lbrakk>P\<rbrakk>\<^sub>P (s, s\<^sub>0) \<and> \<lbrakk>Q\<rbrakk>\<^sub>P (s\<^sub>0, s'))"
  by expr_auto

lemma pred_assigns [pred]: "\<lbrakk>\<langle>\<sigma>\<rangle>\<^sub>a\<rbrakk>\<^sub>P = ($\<^bold>v\<^sup>> = \<sigma>\<^sup><)\<^sub>e"
  by (auto simp add: expr_defs assigns_rel_def lens_defs pfun_entries_pabs pfun_graph_pabs prod.case_eq_if)

lemma rel_assigns [rel]: "\<lbrakk>\<langle>\<sigma>\<rangle>\<^sub>a\<rbrakk>\<^sub>P (s, s') = (s' = \<sigma> s)"
  by (simp add: expr_defs assigns_rel_def pfun_entries_pabs pfun_graph_pabs)

lemma rel_rcond [rel]: "\<lbrakk>P \<^bold>\<lhd> b \<^bold>\<rhd> Q\<rbrakk>\<^sub>P (s, s') = (if b s then \<lbrakk>P\<rbrakk>\<^sub>P (s, s') else \<lbrakk>Q\<rbrakk>\<^sub>P (s, s'))"
  unfolding cond_def by rel_auto

lemma rel_Domain: "Domain P = (\<Union> s. P\<lbrakk>\<guillemotleft>s\<guillemotright>/\<^bold>v\<^sup>>\<rbrakk>) \<down> \<^bold>v\<^sup><"
  by (pred_auto)

lemma pred_pre [pred]: "pre P = (\<exists> s. \<lbrakk>P\<rbrakk>\<^sub>P \<lbrakk>\<guillemotleft>s\<guillemotright>/\<^bold>v\<^sup>>\<rbrakk>)\<^sub><"
  by (expr_simp add: pre_def Domain_iff)

lemma pred_pre_liberate: "pre P = (\<lbrakk>P\<rbrakk>\<^sub>P \\ out\<alpha>)\<^sub><"
  by (expr_auto add: pre_def)

lemma rel_pre [rel_transfer]: "pre P = (\<lambda> s. \<exists> s\<^sub>0. \<lbrakk>P\<rbrakk>\<^sub>P (s, s\<^sub>0))"
  by (auto simp add: pre_def Domain_iff set_pred_def SEXP_def)

lemma rel_frame [rel]: "\<lbrakk>a:[P]\<rbrakk>\<^sub>P (s, s') = (s \<approx>\<^sub>S s' on -a \<and> \<lbrakk>P\<rbrakk>\<^sub>P (s, s'))"
  by (expr_auto add: frame_def)

lemma rel_frame_ext [rel]: "\<lbrakk>a:[P]\<^sub>\<up>\<rbrakk>\<^sub>P (s, s') = (s \<approx>\<^sub>S s' on (-\<lbrakk>a\<rbrakk>\<^sub>\<sim>) \<and> \<lbrakk>P\<rbrakk>\<^sub>P (get\<^bsub>a\<^esub> s, get\<^bsub>a\<^esub> s'))"
  by (expr_auto add: frame_ext_def frame_def subst_app_pred_def)

subsection \<open> Unrestriction Laws \<close>

lemma unrest_iuvar [unrest]: "out\<alpha> \<sharp> ($x\<^sup><)\<^sub>u"
  by rel_auto

lemma unrest_ouvar [unrest]: "in\<alpha> \<sharp> ($x\<^sup>>)\<^sub>u"
  by rel_auto

lemma unrest_seq_ivar [unrest]: "\<lbrakk> mwb_lens x; $x\<^sup>< \<sharp> P \<rbrakk> \<Longrightarrow> $x\<^sup>< \<sharp> P \<Zcomp> Q"
  by rel_auto

lemma unrest_seq_ovar [unrest]: "\<lbrakk> mwb_lens x; $x\<^sup>> \<sharp> Q \<rbrakk> \<Longrightarrow> $x\<^sup>> \<sharp> P \<Zcomp> Q"
  by rel_auto

subsection \<open> Algebraic Laws \<close>

lemma seqr_middle: "vwb_lens x \<Longrightarrow> P \<Zcomp> Q = (\<Union> v. P\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<^sup>>\<rbrakk> \<^bold>; Q\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<^sup><\<rbrakk>)"
  by (rel_auto, metis vwb_lens.put_eq)

lemma precond_equiv: "true \<Zcomp> P = P \<longleftrightarrow> (in\<alpha> \<sharp> P)"
  by (rel_auto)

lemma precond_simp [simp]: "in\<alpha> \<sharp> P \<Longrightarrow> true \<Zcomp> P = P"
  by (simp add: precond_equiv)

lemma postcond_equiv: "P \<Zcomp> true = P \<longleftrightarrow> (out\<alpha> \<sharp> P)"
  by (rel_auto)

lemma postcond_simp: "out\<alpha> \<sharp> P \<Longrightarrow> P \<Zcomp> true = P"
  by (simp add: postcond_equiv)

lemma "($x\<^sup>< = $x\<^sup>>)\<^sub>u \<Zcomp> ($x\<^sup>< = $x\<^sup>>)\<^sub>u = ($x\<^sup>< = $x\<^sup>>)\<^sub>u"
  by rel_auto

lemma assigns_skip: "\<langle>id\<rangle>\<^sub>a = II"
  by rel_auto

lemma assigns_comp: "\<langle>\<sigma>\<rangle>\<^sub>a \<Zcomp> \<langle>\<rho>\<rangle>\<^sub>a = \<langle>\<rho> \<circ>\<^sub>s \<sigma>\<rangle>\<^sub>a"
  by rel_auto

lemma assigns_cond: "\<langle>\<sigma>\<rangle>\<^sub>a \<^bold>\<lhd> b \<^bold>\<rhd> \<langle>\<rho>\<rangle>\<^sub>a = \<langle>\<sigma> \<triangleleft> b \<triangleright> \<rho>\<rangle>\<^sub>a"
  by rel_auto

end