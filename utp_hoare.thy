theory utp_hoare
imports utp_rel_laws
begin

text \<open>Hoare triples\<close>

definition hoare_r :: "('s \<Rightarrow> bool) \<Rightarrow> 's rel \<Rightarrow> ('s \<Rightarrow> bool) \<Rightarrow> bool" where
[rel]: "hoare_r p Q r = ((p\<^sup>< \<longrightarrow> r\<^sup>>)\<^sub>u \<sqsubseteq> Q)"

syntax "_hoare_r" :: "logic \<Rightarrow> logic \<Rightarrow> logic \<Rightarrow> logic" ("\<^bold>{_\<^bold>}/ _/ \<^bold>{_\<^bold>}")
translations "_hoare_r P S Q" == "CONST hoare_r (P)\<^sub>e S (Q)\<^sub>e"

named_theorems hoare and hoare_safe

thm relcomp_unfold Id_on_iff

lemma relcomp_iff: "(a, b) \<in> P O Q \<longleftrightarrow> (\<exists> c. (a, c) \<in> P \<and> (c, b) \<in> Q)"
  by (simp add: relcomp_unfold)

lemma hoare_meaning: "\<^bold>{p\<^bold>}Q\<^bold>{r\<^bold>} = (\<forall> s s'. p s \<and> (s, s') \<in> Q \<longrightarrow> r s')"
  by (rel_auto)

lemma hoare_alt_def: "\<^bold>{b\<^bold>}P\<^bold>{c\<^bold>} = (P \<Zcomp> \<questiondown>c? \<sqsubseteq> \<questiondown>b? \<Zcomp> P)"
  by (rel_auto)

lemma hoare_assume: "\<^bold>{P\<^bold>}S\<^bold>{Q\<^bold>} \<Longrightarrow> \<questiondown>P? \<Zcomp> S = \<questiondown>P? \<Zcomp> S \<Zcomp> \<questiondown>Q?"
  by (rel_auto)

lemma hoare_pre_assume_1: "\<^bold>{b \<and> c\<^bold>}P\<^bold>{d\<^bold>} = \<^bold>{c\<^bold>}\<questiondown>b? \<Zcomp> P\<^bold>{d\<^bold>}"
  by (rel_auto)

lemma hoare_pre_assume_2: "\<^bold>{b \<and> c\<^bold>}P\<^bold>{d\<^bold>} = \<^bold>{b\<^bold>}\<questiondown>c? \<Zcomp> P\<^bold>{d\<^bold>}"
  by rel_auto
                               
lemma hoare_test [hoare_safe]: "`p \<and> b \<longrightarrow> q` \<Longrightarrow> \<^bold>{p\<^bold>}\<questiondown>b?\<^bold>{q\<^bold>}"
  by rel_auto

lemma hoare_gcmd' [hoare_safe]: "\<^bold>{p \<and> b\<^bold>}P\<^bold>{q\<^bold>} \<Longrightarrow> \<^bold>{p\<^bold>}\<questiondown>b? \<Zcomp> P\<^bold>{q\<^bold>}"
  by rel_auto

(*
lemma hoare_gcmd [hoare_safe]: "\<^bold>{p \<and> b\<^bold>}P\<^bold>{q\<^bold>} \<Longrightarrow> \<^bold>{p\<^bold>}b \<longrightarrow> P\<^bold>{q\<^bold>}"
  by (rel_auto)
*)

lemma hoare_r_conj [hoare_safe]: "\<lbrakk> \<^bold>{p\<^bold>}Q\<^bold>{r\<^bold>}; \<^bold>{p\<^bold>}Q\<^bold>{s\<^bold>} \<rbrakk> \<Longrightarrow> \<^bold>{p\<^bold>}Q\<^bold>{r \<and> s\<^bold>}"
  by rel_auto

lemma hoare_r_weaken_pre [hoare]:
  "\<^bold>{p\<^bold>}Q\<^bold>{r\<^bold>} \<Longrightarrow> \<^bold>{p \<and> q\<^bold>}Q\<^bold>{r\<^bold>}"
  "\<^bold>{q\<^bold>}Q\<^bold>{r\<^bold>} \<Longrightarrow> \<^bold>{p \<and> q\<^bold>}Q\<^bold>{r\<^bold>}"
  by rel_auto+

lemma pre_str_hoare_r:
  assumes "`p\<^sub>1 \<longrightarrow> p\<^sub>2`" and "\<^bold>{p\<^sub>2\<^bold>}C\<^bold>{q\<^bold>}"
  shows "\<^bold>{p\<^sub>1\<^bold>}C\<^bold>{q\<^bold>}"
  using assms by rel_auto
    
lemma post_weak_hoare_r:
  assumes "\<^bold>{p\<^bold>}C\<^bold>{q\<^sub>2\<^bold>}" and "`q\<^sub>2 \<longrightarrow> q\<^sub>1`"
  shows "\<^bold>{p\<^bold>}C\<^bold>{q\<^sub>1\<^bold>}" 
  using assms by rel_auto

lemma hoare_r_conseq: "\<lbrakk> \<^bold>{p\<^sub>2\<^bold>}S\<^bold>{q\<^sub>2\<^bold>}; `p\<^sub>1 \<longrightarrow> p\<^sub>2`; `q\<^sub>2 \<longrightarrow> q\<^sub>1` \<rbrakk> \<Longrightarrow> \<^bold>{p\<^sub>1\<^bold>}S\<^bold>{q\<^sub>1\<^bold>}"
  by rel_auto

lemma hoare_r_cut:
  assumes "\<^bold>{b\<^bold>}P\<^bold>{b\<^bold>}" "\<^bold>{b \<and> c\<^bold>}P\<^bold>{c\<^bold>}"
  shows "\<^bold>{b \<and> c\<^bold>}P\<^bold>{b \<and> c\<^bold>}"
  using assms by rel_auto

lemma hoare_r_cut_simple: 
  assumes "\<^bold>{b\<^bold>}P\<^bold>{b\<^bold>}" "\<^bold>{c\<^bold>}P\<^bold>{c\<^bold>}"
  shows "\<^bold>{b \<and> c\<^bold>}P\<^bold>{b \<and> c\<^bold>}"
  using assms by rel_auto

lemma hoare_oracle: "\<^bold>{p\<^bold>}false\<^bold>{q\<^bold>}"
  by (simp add: hoare_r_def)

subsection \<open> Sequence Laws \<close>

lemma seq_hoare_r: "\<lbrakk> \<^bold>{p\<^bold>}Q\<^sub>1\<^bold>{s\<^bold>} ; \<^bold>{s\<^bold>}Q\<^sub>2\<^bold>{r\<^bold>} \<rbrakk> \<Longrightarrow> \<^bold>{p\<^bold>}Q\<^sub>1 \<Zcomp> Q\<^sub>2\<^bold>{r\<^bold>}"
  by (rel_force)
 
lemma seq_hoare_invariant [hoare_safe]: "\<lbrakk> \<^bold>{p\<^bold>}Q\<^sub>1\<^bold>{p\<^bold>} ; \<^bold>{p\<^bold>}Q\<^sub>2\<^bold>{p\<^bold>} \<rbrakk> \<Longrightarrow> \<^bold>{p\<^bold>}Q\<^sub>1 \<Zcomp> Q\<^sub>2\<^bold>{p\<^bold>}"
  by (rel_force)

lemma seq_hoare_stronger_pre_1 [hoare_safe]: 
  "\<lbrakk> \<^bold>{p \<and> q\<^bold>}Q\<^sub>1\<^bold>{p \<and> q\<^bold>} ; \<^bold>{p \<and> q\<^bold>}Q\<^sub>2\<^bold>{q\<^bold>} \<rbrakk> \<Longrightarrow> \<^bold>{p \<and> q\<^bold>}Q\<^sub>1 \<Zcomp> Q\<^sub>2\<^bold>{q\<^bold>}"
  using seq_hoare_r by blast

lemma seq_hoare_stronger_pre_2 [hoare_safe]: 
  "\<lbrakk> \<^bold>{p \<and> q\<^bold>}Q\<^sub>1\<^bold>{p \<and> q\<^bold>} ; \<^bold>{p \<and> q\<^bold>}Q\<^sub>2\<^bold>{p\<^bold>} \<rbrakk> \<Longrightarrow> \<^bold>{p \<and> q\<^bold>}Q\<^sub>1 \<Zcomp> Q\<^sub>2\<^bold>{p\<^bold>}"
  using seq_hoare_r by blast
    
lemma seq_hoare_inv_r_2 [hoare]: "\<lbrakk> \<^bold>{p\<^bold>}Q\<^sub>1\<^bold>{q\<^bold>} ; \<^bold>{q\<^bold>}Q\<^sub>2\<^bold>{q\<^bold>} \<rbrakk> \<Longrightarrow> \<^bold>{p\<^bold>}Q\<^sub>1 \<Zcomp> Q\<^sub>2\<^bold>{q\<^bold>}"
  using seq_hoare_r by blast

lemma seq_hoare_inv_r_3 [hoare]: "\<lbrakk> \<^bold>{p\<^bold>}Q\<^sub>1\<^bold>{p\<^bold>} ; \<^bold>{p\<^bold>}Q\<^sub>2\<^bold>{q\<^bold>} \<rbrakk> \<Longrightarrow> \<^bold>{p\<^bold>}Q\<^sub>1 \<Zcomp> Q\<^sub>2\<^bold>{q\<^bold>}"
  using seq_hoare_r by blast

subsection \<open> Assignment Laws \<close>

lemma assigns_hoare_r [hoare_safe]: "`p \<longrightarrow> \<sigma> \<dagger> q` \<Longrightarrow> \<^bold>{p\<^bold>}\<langle>\<sigma>\<rangle>\<^sub>a\<^bold>{q\<^bold>}"
  by rel_auto
  
lemma assigns_backward_hoare_r: 
  "\<^bold>{\<sigma> \<dagger> p\<^bold>}\<langle>\<sigma>\<rangle>\<^sub>a\<^bold>{p\<^bold>}"
  by rel_auto

lemma assign_floyd_hoare_r:
  assumes "vwb_lens x"
  shows "\<^bold>{p\<^bold>} x := e \<^bold>{\<exists> v . p\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<rbrakk> \<and> $x = e\<lbrakk>\<guillemotleft>v\<guillemotright>/x\<rbrakk>\<^bold>}"
  using assms
  by (rel_auto, metis lens_override_def lens_override_idem)

lemma assigns_init_hoare [hoare_safe]:
  "\<lbrakk> vwb_lens x; $x \<sharp> p; $x \<sharp> v; \<^bold>{$x = v \<and> p\<^bold>}S\<^bold>{q\<^bold>} \<rbrakk> \<Longrightarrow> \<^bold>{p\<^bold>}(x := v) \<Zcomp> S\<^bold>{q\<^bold>}"
  by rel_auto

lemma assigns_init_hoare_general:
  "\<lbrakk> vwb_lens x; \<And> x\<^sub>0. \<^bold>{$x = v\<lbrakk>\<guillemotleft>x\<^sub>0\<guillemotright>/x\<rbrakk> \<and> p\<lbrakk>\<guillemotleft>x\<^sub>0\<guillemotright>/x\<rbrakk>\<^bold>}S\<^bold>{q\<^bold>} \<rbrakk> \<Longrightarrow> \<^bold>{p\<^bold>}(x := v) \<Zcomp> S\<^bold>{q\<^bold>}"
  by (rule seq_hoare_r, rule assign_floyd_hoare_r, simp, rel_auto)

lemma assigns_final_hoare [hoare_safe]:
  "\<^bold>{p\<^bold>}S\<^bold>{\<sigma> \<dagger> q\<^bold>} \<Longrightarrow> \<^bold>{p\<^bold>}S \<Zcomp> \<langle>\<sigma>\<rangle>\<^sub>a\<^bold>{q\<^bold>}"
  by (rel_auto)

lemma skip_hoare_r [hoare_safe]: "\<^bold>{p\<^bold>}II\<^bold>{p\<^bold>}"
  by rel_auto

lemma skip_hoare_impl_r [hoare_safe]: "`p \<longrightarrow> q` \<Longrightarrow> \<^bold>{p\<^bold>}II\<^bold>{q\<^bold>}"
  by rel_auto  

subsection \<open> Conditional Laws \<close>

lemma cond_hoare_r [hoare_safe]: "\<lbrakk> \<^bold>{b \<and> p\<^bold>}S\<^bold>{q\<^bold>} ; \<^bold>{\<not>b \<and> p\<^bold>}T\<^bold>{q\<^bold>} \<rbrakk> \<Longrightarrow> \<^bold>{p\<^bold>}S \<^bold>\<lhd> b \<^bold>\<rhd> T\<^bold>{q\<^bold>}"
  unfolding cond_def by rel_simp pred_auto

lemma cond_hoare_r_wp: 
  assumes "\<^bold>{p'\<^bold>}S\<^bold>{q\<^bold>}" and "\<^bold>{p''\<^bold>}T\<^bold>{q\<^bold>}"
  shows "\<^bold>{(b \<and> p') \<or> (\<not>b \<and> p'')\<^bold>} S \<^bold>\<lhd> b \<^bold>\<rhd> T \<^bold>{q\<^bold>}"
  using assms unfolding cond_def by rel_simp pred_auto

lemma cond_hoare_r_sp:
  assumes "\<^bold>{(b \<and> p)\<^bold>}S\<^bold>{q\<^bold>}" and "\<^bold>{\<not>b \<and> p\<^bold>}T\<^bold>{s\<^bold>}"
  shows "\<^bold>{p\<^bold>}S \<^bold>\<lhd> b \<^bold>\<rhd> T\<^bold>{q \<or> s\<^bold>}"
  using assms unfolding cond_def by rel_simp pred_auto

lemma hoare_ndet [hoare_safe]: 
  assumes "\<^bold>{p\<^bold>}P\<^bold>{q\<^bold>}" "\<^bold>{p\<^bold>}Q\<^bold>{q\<^bold>}"
  shows "\<^bold>{p\<^bold>}(P \<union> Q)\<^bold>{q\<^bold>}"
  using assms by (rel_auto)

lemma hoare_disj [hoare_safe]: 
  assumes "\<^bold>{p\<^bold>}P\<^bold>{q\<^bold>}" "\<^bold>{p\<^bold>}Q\<^bold>{q\<^bold>}"
  shows "\<^bold>{p\<^bold>}(P \<or> Q)\<^bold>{q\<^bold>}"
  using assms by (rel_auto)

lemma hoare_UINF [hoare_safe]:
  assumes "\<And>i. i \<in> A \<Longrightarrow> \<^bold>{p\<^bold>}P(i)\<^bold>{q\<^bold>}"
  shows "\<^bold>{p\<^bold>}(\<Union> {P(i)|i. i\<in>A})\<^bold>{q\<^bold>}"
  using assms by (rel_auto, meson hoare_meaning)


subsection \<open> Recursion Laws \<close>

lemma nu_hoare_r_partial: 
  assumes induct_step: "\<And>P st. \<^bold>{p\<^bold>}P\<^bold>{q\<^bold>} \<Longrightarrow> \<^bold>{p\<^bold>}F P\<^bold>{q\<^bold>}"   
  shows "\<^bold>{p\<^bold>}\<nu> F\<^bold>{q\<^bold>}"
  using induct_step by (rel_auto add: lfp_lowerbound)

lemma mu_hoare_r:
  assumes WF: "wf R"
  assumes M:"mono F"  
  assumes induct_step:
    "\<And> st P. \<^bold>{p \<and> (e,\<guillemotleft>st\<guillemotright>) \<in> \<guillemotleft>R\<guillemotright>\<^bold>}P\<^bold>{q\<^bold>} \<Longrightarrow> \<^bold>{p \<and> e = \<guillemotleft>st\<guillemotright>\<^bold>}F P\<^bold>{q\<^bold>}"   
  shows "\<^bold>{p\<^bold>}\<mu> F \<^bold>{q\<^bold>}"
  unfolding hoare_r_def
proof (rule mu_rec_total_utp_rule[OF WF M , of _ e ], goal_cases)
  case (1 st)
  then show ?case 
    using induct_step[unfolded hoare_r_def, of st "(p\<^sup>< \<and> (e\<^sup><, \<guillemotleft>st\<guillemotright>) \<in> \<guillemotleft>R\<guillemotright> \<longrightarrow> q\<^sup>>)\<^sub>u"]
      by (simp add: usubst)
qed
    
lemma mu_hoare_r':
  assumes WF: "wf R"
  assumes M:"mono F"  
  assumes induct_step:
    "\<And> st P. \<^bold>{p \<and> (e,\<guillemotleft>st\<guillemotright>) \<in> \<guillemotleft>R\<guillemotright>\<^bold>} P \<^bold>{q\<^bold>} \<Longrightarrow> \<^bold>{p \<and> e = \<guillemotleft>st\<guillemotright>\<^bold>} F P \<^bold>{q\<^bold>}" 
  assumes I0: "`p' \<longrightarrow> p`"  
  shows "\<^bold>{p'\<^bold>} \<mu> F \<^bold>{q\<^bold>}"
  using I0 M WF assms(3) mu_hoare_r pre_str_hoare_r by blast

subsection \<open> Iteration Rules \<close>

lemma iter_hoare_r [hoare_safe]: "\<^bold>{P\<^bold>}S\<^bold>{P\<^bold>} \<Longrightarrow> \<^bold>{P\<^bold>}S\<^sup>*\<^bold>{P\<^bold>}"
   using rtrancl_induct by (rel_auto, fastforce)

lemma while_hoare_r [hoare_safe]:
  assumes "\<^bold>{p \<and> b\<^bold>}S\<^bold>{p\<^bold>}"
  shows "\<^bold>{p\<^bold>}while b do S od\<^bold>{\<not>b \<and> p\<^bold>}"
proof (simp add: while_top_def hoare_r_def assms)
  have "(p\<^sup>< \<longrightarrow> (\<not> b \<and> p)\<^sup>>)\<^sub>u \<sqsubseteq> S \<Zcomp> (p\<^sup>< \<longrightarrow> (\<not> b \<and> p)\<^sup>>)\<^sub>u \<^bold>\<lhd> b \<^bold>\<rhd> II"
    using assms by rel_auto
  then show "(p\<^sup>< \<longrightarrow> (\<not> b \<and> p)\<^sup>>)\<^sub>u \<sqsubseteq> (\<nu> X \<bullet> S \<Zcomp> X \<^bold>\<lhd> b \<^bold>\<rhd> II)"
    by (simp add: lfp_lowerbound ref_by_def)
qed

lemma while_invr_hoare_r [hoare_safe]:
  assumes "\<^bold>{p \<and> b\<^bold>}S\<^bold>{p\<^bold>}" "`pre' \<longrightarrow> p`" "`(\<not>b \<and> p) \<longrightarrow> post'`"
  shows "\<^bold>{pre'\<^bold>}while b invr p do S od\<^bold>{post'\<^bold>}"
  unfolding while_inv_def using assms while_hoare_r hoare_r_conseq by blast

lemma while_r_minimal_partial:
  assumes seq_step: "`p \<longrightarrow> invar`"
  assumes induct_step: "\<^bold>{invar \<and> b\<^bold>} C \<^bold>{invar\<^bold>}"  
  shows "\<^bold>{p\<^bold>}while b do C od\<^bold>{\<not>b \<and> invar\<^bold>}"
  using induct_step pre_str_hoare_r seq_step while_hoare_r by blast

(*lemma approx_chain: 
  "(\<Sqinter>n::nat. \<lceil>p \<and> v <\<^sub>u \<guillemotleft>n\<guillemotright>\<rceil>\<^sub><) = \<lceil>p\<rceil>\<^sub><"
  by (rel_auto)*)

text \<open> Total correctness law for Hoare logic, based on constructive chains. This is limited to
  variants that have naturals numbers as their range. \<close>
    
lemma while_term_hoare_r:
  assumes "\<And> z::nat. \<^bold>{p \<and> b \<and> v = \<guillemotleft>z\<guillemotright>\<^bold>}S\<^bold>{p \<and> v < \<guillemotleft>z\<guillemotright>\<^bold>}"
  shows "\<^bold>{p\<^bold>}while\<^sub>\<bottom> b do S od\<^bold>{\<not>b \<and> p\<^bold>}"
proof -
  have "((p\<^sup><)\<^sub>u \<Rightarrow> ((\<not> b \<and> p)\<^sup>>)\<^sub>u) \<sqsubseteq> (\<mu> X \<bullet> S \<Zcomp> X \<^bold>\<lhd> b \<^bold>\<rhd> II)"
  proof (rule mu_refine_intro)
    from assms show "((p\<^sup><)\<^sub>u \<Rightarrow> ((\<not> b \<and> p)\<^sup>>)\<^sub>u) \<sqsubseteq> S \<Zcomp> ((p\<^sup><)\<^sub>u \<Rightarrow> ((\<not> b \<and> p)\<^sup>>)\<^sub>u) \<^bold>\<lhd> b \<^bold>\<rhd> II"
      by (rel_auto; smt (z3) hoare_meaning)+
    let ?E = "\<lambda> n. \<lbrakk>(p \<and> v < \<guillemotleft>n\<guillemotright>)\<^sup><\<rbrakk>\<^sub>u"
    show "((p\<^sup><)\<^sub>u \<and> (\<mu> X \<bullet> S \<Zcomp> X \<^bold>\<lhd> b \<^bold>\<rhd> II)) = ((p\<^sup><)\<^sub>u \<and> (\<nu> X \<bullet> S \<Zcomp> X \<^bold>\<lhd> b \<^bold>\<rhd> II))"
    proof (rule constr_fp_uniq[where E="?E"])
      show "mono (\<lambda>X. S \<Zcomp> X \<^bold>\<lhd> b \<^bold>\<rhd> II)"
        by (rule cond_seqr_mono)
      show "constr (\<lambda>X. S \<Zcomp> X \<^bold>\<lhd> b \<^bold>\<rhd> II) ?E"
        apply (rule constrI, rule chainI)
          apply (rel_auto)+
        by (smt (verit, del_insts) assms hoare_meaning less_Suc_eq order_less_trans)+
    qed rel_auto (* Couldn't pattern match last goal *)
  qed
  thus ?thesis
    by (rel_auto add: while_bot_def)
qed

lemma while_vrt_hoare_r [hoare_safe]:
  assumes "\<And> z::nat. \<^bold>{p \<and> b \<and> v = \<guillemotleft>z\<guillemotright>\<^bold>}S\<^bold>{p \<and> v < \<guillemotleft>z\<guillemotright>\<^bold>}" "`pre S \<longrightarrow> p`" "`(\<not>b \<and> p) \<longrightarrow> post S`"
  shows "\<^bold>{pre\<^bold>}while b invr p vrt v do S od\<^bold>{post\<^bold>}"
  apply (rule hoare_r_conseq[OF _ assms(2) assms(3)])
  apply (simp add: while_vrt_def)
  apply (rule while_term_hoare_r[where v="v", OF assms(1)]) 
  done
  
text \<open> General total correctness law based on well-founded induction \<close>

(*
lemma while_wf_hoare_r:
  assumes WF: "wf R"
  assumes I0: "`p' \<longrightarrow> p`"
  assumes induct_step:"\<And> st. \<^bold>{b \<and> p \<and> e = \<guillemotleft>st\<guillemotright>\<^bold>}Q\<^bold>{p \<and> (e, \<guillemotleft>st\<guillemotright>) \<in> \<guillemotleft>R\<guillemotright>\<^bold>}"
  assumes PHI:"`(\<not>b \<and> p) \<longrightarrow> q'`"  
  shows "\<^bold>{p'\<^bold>}while\<^sub>\<bottom> b invr p do Q od\<^bold>{q'\<^bold>}"
  unfolding hoare_r_def while_inv_bot_def while_bot_def
proof (rule pre_weak_rel[of _ "\<lceil>p\<rceil>\<^sub><" ])
  from I0 show "`\<lceil>pre\<rceil>\<^sub>< \<Rightarrow> \<lceil>p\<rceil>\<^sub><`"
    by rel_auto
  show "(\<lceil>p\<rceil>\<^sub>< \<Rightarrow> \<lceil>post\<rceil>\<^sub>>) \<sqsubseteq> (\<mu> X \<bullet> Q \<Zcomp> X \<triangleleft> b \<triangleright>\<^sub>r II)"
  proof (rule mu_rec_total_utp_rule[where e=e, OF WF])
    show "Monotonic (\<lambda>X. Q \<Zcomp> X \<triangleleft> b \<triangleright>\<^sub>r II)"
      by (simp add: closure)
    have induct_step': "\<And> st. (\<lceil>b \<and> p \<and>  e = \<guillemotleft>st\<guillemotright> \<rceil>\<^sub>< \<Rightarrow> (\<lceil>p \<and> (e,\<guillemotleft>st\<guillemotright>) \<in> \<guillemotleft>R\<guillemotright> \<rceil>\<^sub>> )) \<sqsubseteq> Q"
      using induct_step by rel_auto  
    with PHI
    show "\<And>st. (\<lceil>p\<rceil>\<^sub>< \<and> \<lceil>e\<rceil>\<^sub>< = \<guillemotleft>st\<guillemotright> \<Rightarrow> \<lceil>post\<rceil>\<^sub>>) \<sqsubseteq> Q \<Zcomp> (\<lceil>p\<rceil>\<^sub>< \<and> (\<lceil>e\<rceil>\<^sub><, \<guillemotleft>st\<guillemotright>) \<in> \<guillemotleft>R\<guillemotright> \<Rightarrow> \<lceil>post\<rceil>\<^sub>>) \<triangleleft> b \<triangleright>\<^sub>r II" 
      by (rel_auto)
  qed       
qed*)

subsection \<open> Frame Rules \<close>

text \<open> Frame rule: If starting $S$ in a state satisfying $p establishes q$ in the final state, then
  we can insert an invariant predicate $r$ when $S$ is framed by $a$, provided that $r$ does not
  refer to variables in the frame, and $q$ does not refer to variables outside the frame. \<close>

(* TODO - Fix all these metis proofs *)

lemma frame_hoare_r:
  assumes "idem_scene a" "a \<sharp> r" "-a \<sharp> q" "\<^bold>{p\<^bold>}P\<^bold>{q\<^bold>}"
  shows "\<^bold>{p \<and> r\<^bold>}a:[P]\<^bold>{q \<and> r\<^bold>}"
  using assms
  apply (rel_auto)
   apply (metis (mono_tags, lifting) Product_Type.Collect_case_prodD frame_def fst_conv hoare_meaning snd_conv)
  by (metis (mono_tags, lifting) Product_Type.Collect_case_prodD frame_def fst_eqD scene_equiv_def scene_override_commute snd_eqD)

lemma frame_strong_hoare_r [hoare_safe]: 
  assumes "idem_scene a" "a \<sharp> r" "-a \<sharp> q" "\<^bold>{p \<and> r\<^bold>}S\<^bold>{q\<^bold>}"
  shows "\<^bold>{p \<and> r\<^bold>}a:[S]\<^bold>{q \<and> r\<^bold>}"
  using assms apply (rel_auto)
   apply (metis (mono_tags, lifting) SEXP_def hoare_meaning rel_frame set_pred_def)
  by (metis SEXP_def rel_frame scene_equiv_def scene_override_commute set_pred_def)

lemma frame_hoare_r' [hoare_safe]: 
  assumes "idem_scene a" "a \<sharp> r" "-a \<sharp> q" "\<^bold>{r \<and> p\<^bold>}S\<^bold>{q\<^bold>}"
  shows "\<^bold>{r \<and> p\<^bold>}a:[S]\<^bold>{r \<and> q\<^bold>}"
  using assms apply (rel_auto)
   apply (metis SEXP_def rel_frame scene_equiv_def scene_override_commute set_pred_def)
  by (metis (mono_tags, lifting) Product_Type.Collect_case_prodD frame_def fst_conv hoare_meaning snd_conv)

lemma antiframe_hoare_r:
  assumes "idem_scene a" "-a \<sharp> r" "a \<sharp> q" "\<^bold>{p\<^bold>}P\<^bold>{q\<^bold>}"  
  shows "\<^bold>{p \<and> r\<^bold>} (-a):[P] \<^bold>{q \<and> r\<^bold>}"
  using assms apply (rel_auto)
   apply (metis (mono_tags, lifting) Product_Type.Collect_case_prodD frame_def fst_conv hoare_meaning snd_conv)
  by (metis (full_types) SEXP_def rel_frame scene_equiv_def scene_override_commute set_pred_def)
    
lemma antiframe_strong_hoare_r:
  assumes "idem_scene a" "-a \<sharp> r" "a \<sharp> q" "\<^bold>{p \<and> r\<^bold>}P\<^bold>{q\<^bold>}"  
  shows "\<^bold>{p \<and> r\<^bold>} (-a):[P] \<^bold>{q \<and> r\<^bold>}"
  using assms  apply (rel_auto)
   apply (metis (mono_tags, lifting) Product_Type.Collect_case_prodD frame_def fst_conv hoare_meaning snd_conv)
  by (metis (full_types) SEXP_def rel_frame scene_equiv_def scene_override_commute set_pred_def)


lemma nmods_invariant:
  assumes "S nmods a" "-a \<sharp> p"
  shows "\<^bold>{p\<^bold>}S\<^bold>{p\<^bold>}"
  using assms apply rel_auto
  by (metis Healthy_def SEXP_def rel_frame scene_equiv_def scene_override_commute set_pred_def)

lemma hoare_r_ghost:
  assumes "vwb_lens x" "x \<sharp> p" "x \<sharp> q" "S nuses x" "\<^bold>{p\<^bold>}x := e\<Zcomp> S\<^bold>{q\<^bold>}"
  shows "\<^bold>{p\<^bold>}S\<^bold>{q\<^bold>}" 
proof -
  have "\<^bold>{p\<^bold>}x := e\<Zcomp> rrestr x S\<^bold>{q\<^bold>}"
    by (simp add: Healthy_if assms(4) assms(5))
  with assms(1-3) have "\<^bold>{p\<^bold>}rrestr x S\<^bold>{q\<^bold>}"
    by (rel_simp,metis mwb_lens.put_put vwb_lens_mwb)
  thus ?thesis
    by (simp add: Healthy_if assms(4))
qed

end