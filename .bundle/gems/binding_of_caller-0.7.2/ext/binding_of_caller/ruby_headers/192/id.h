/* DO NOT EDIT THIS FILE DIRECTLY */
/**********************************************************************

  id.h -

  $Author$
  created at: Sun Oct 19 21:12:51 2008

  Copyright (C) 2007 Koichi Sasada

**********************************************************************/

#ifndef RUBY_ID_H
#define RUBY_ID_H

#define ID_SCOPE_SHIFT 3
#define ID_SCOPE_MASK 0x07
#define ID_LOCAL      0x00
#define ID_INSTANCE   0x01
#define ID_GLOBAL     0x03
#define ID_ATTRSET    0x04
#define ID_CONST      0x05
#define ID_CLASS      0x06
#define ID_JUNK       0x07
#define ID_INTERNAL   ID_JUNK

#ifdef USE_PARSE_H
#include "parse.h"
#endif

#define symIFUNC ID2SYM(idIFUNC)
#define symCFUNC ID2SYM(idCFUNC)

#if !defined tLAST_TOKEN && defined YYTOKENTYPE
#define tLAST_TOKEN tLAST_TOKEN
#endif

enum ruby_method_ids {
#ifndef tLAST_TOKEN
    tUPLUS = 321,
    tUMINUS = 322,
    tPOW = 323,
    tCMP = 324,
    tEQ = 325,
    tEQQ = 326,
    tNEQ = 327,
    tGEQ = 328,
    tLEQ = 329,
    tANDOP = 330,
    tOROP = 331,
    tMATCH = 332,
    tNMATCH = 333,
    tDOT2 = 334,
    tDOT3 = 335,
    tAREF = 336,
    tASET = 337,
    tLSHFT = 338,
    tRSHFT = 339,
    tLAMBDA = 352,
    idNULL = 365,
    idRespond_to = 366,
    idIFUNC = 367,
    idCFUNC = 368,
    id_core_set_method_alias = 369,
    id_core_set_variable_alias = 370,
    id_core_undef_method = 371,
    id_core_define_method = 372,
    id_core_define_singleton_method = 373,
    id_core_set_postexe = 374,
    tLAST_TOKEN = 375,
#endif
    idDot2 = tDOT2,
    idDot3 = tDOT3,
    idUPlus = tUPLUS,
    idUMinus = tUMINUS,
    idPow = tPOW,
    idCmp = tCMP,
    idPLUS = '+',
    idMINUS = '-',
    idMULT = '*',
    idDIV = '/',
    idMOD = '%',
    idLT = '<',
    idLTLT = tLSHFT,
    idLE = tLEQ,
    idGT = '>',
    idGE = tGEQ,
    idEq = tEQ,
    idEqq = tEQQ,
    idNeq = tNEQ,
    idNot = '!',
    idBackquote = '`',
    idEqTilde = tMATCH,
    idNeqTilde = tNMATCH,
    idAREF = tAREF,
    idASET = tASET,
    idLAST_TOKEN = tLAST_TOKEN >> ID_SCOPE_SHIFT,
    tIntern,
    tMethodMissing,
    tLength,
    tSize,
    tGets,
    tSucc,
    tEach,
    tLambda,
    tSend,
    t__send__,
    tInitialize,
    tUScore,
#if SUPPORT_JOKE
    tBitblt,
    tAnswer,
#endif
    tLAST_ID,
#define TOKEN2ID(n) id##n = ((t##n<<ID_SCOPE_SHIFT)|ID_LOCAL)
#if SUPPORT_JOKE
    TOKEN2ID(Bitblt),
    TOKEN2ID(Answer),
#endif
    TOKEN2ID(Intern),
    TOKEN2ID(MethodMissing),
    TOKEN2ID(Length),
    TOKEN2ID(Size),
    TOKEN2ID(Gets),
    TOKEN2ID(Succ),
    TOKEN2ID(Each),
    TOKEN2ID(Lambda),
    TOKEN2ID(Send),
    TOKEN2ID(__send__),
    TOKEN2ID(Initialize),
    TOKEN2ID(UScore),
    TOKEN2ID(LAST_ID)
};

#ifdef tLAST_TOKEN
struct ruby_method_ids_check {
#define ruby_method_id_check_for(name, value) \
    int checking_for_##name[name == value ? 1 : -1]
ruby_method_id_check_for(tUPLUS, 321);
ruby_method_id_check_for(tUMINUS, 322);
ruby_method_id_check_for(tPOW, 323);
ruby_method_id_check_for(tCMP, 324);
ruby_method_id_check_for(tEQ, 325);
ruby_method_id_check_for(tEQQ, 326);
ruby_method_id_check_for(tNEQ, 327);
ruby_method_id_check_for(tGEQ, 328);
ruby_method_id_check_for(tLEQ, 329);
ruby_method_id_check_for(tANDOP, 330);
ruby_method_id_check_for(tOROP, 331);
ruby_method_id_check_for(tMATCH, 332);
ruby_method_id_check_for(tNMATCH, 333);
ruby_method_id_check_for(tDOT2, 334);
ruby_method_id_check_for(tDOT3, 335);
ruby_method_id_check_for(tAREF, 336);
ruby_method_id_check_for(tASET, 337);
ruby_method_id_check_for(tLSHFT, 338);
ruby_method_id_check_for(tRSHFT, 339);
ruby_method_id_check_for(tLAMBDA, 352);
ruby_method_id_check_for(idNULL, 365);
ruby_method_id_check_for(idRespond_to, 366);
ruby_method_id_check_for(idIFUNC, 367);
ruby_method_id_check_for(idCFUNC, 368);
ruby_method_id_check_for(id_core_set_method_alias, 369);
ruby_method_id_check_for(id_core_set_variable_alias, 370);
ruby_method_id_check_for(id_core_undef_method, 371);
ruby_method_id_check_for(id_core_define_method, 372);
ruby_method_id_check_for(id_core_define_singleton_method, 373);
ruby_method_id_check_for(id_core_set_postexe, 374);
ruby_method_id_check_for(tLAST_TOKEN, 375);
};
#endif

#endif /* RUBY_ID_H */
