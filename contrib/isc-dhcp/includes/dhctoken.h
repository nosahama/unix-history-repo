/* dhctoken.h

   Tokens for config file lexer and parser. */

/*
 * Copyright (c) 1996-2002 Internet Software Consortium.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of The Internet Software Consortium nor the names
 *    of its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE INTERNET SOFTWARE CONSORTIUM AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE INTERNET SOFTWARE CONSORTIUM OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * This software has been written for the Internet Software Consortium
 * by Ted Lemon in cooperation with Vixie Enterprises and Nominum, Inc.
 * To learn more about the Internet Software Consortium, see
 * ``http://www.isc.org/''.  To learn more about Vixie Enterprises,
 * see ``http://www.vix.com''.   To learn more about Nominum, Inc., see
 * ``http://www.nominum.com''.
 */

enum dhcp_token {
	SEMI = ';',
	DOT = '.',
	COLON = ':',
	COMMA = ',',
	SLASH = '/',
	LBRACE = '{',
	RBRACE = '}',
	LPAREN = '(',
	RPAREN = ')',
	EQUAL = '=',
	BANG = '!',
	PERCENT = '%',
 	PLUS = '+',
	MINUS = '-',
	ASTERISK = '*',
	AMPERSAND = '&',
	PIPE = '|',
	CARET = '^',

	HOST = 256,
	FIRST_TOKEN = HOST,
	HARDWARE = 257,
	FILENAME = 258,
	FIXED_ADDR = 259,
	OPTION = 260,
	ETHERNET = 261,
	STRING = 262,
	NUMBER = 263,
	NUMBER_OR_NAME = 264,
	NAME = 265,
	TIMESTAMP = 266,
	STARTS = 267,
	ENDS = 268,
	UID = 269,
	CLASS = 270,
	LEASE = 271,
	RANGE = 272,
	PACKET = 273,
	CIADDR = 274,
	YIADDR = 275,
	SIADDR = 276,
	GIADDR = 277,
	SUBNET = 278,
	NETMASK = 279,
	DEFAULT_LEASE_TIME = 280,
	MAX_LEASE_TIME = 281,
	VENDOR_CLASS = 282,
	USER_CLASS = 283,
	SHARED_NETWORK = 284,
	SERVER_NAME = 285,
	DYNAMIC_BOOTP = 286,
	SERVER_IDENTIFIER = 287,
	DYNAMIC_BOOTP_LEASE_CUTOFF = 288,
	DYNAMIC_BOOTP_LEASE_LENGTH = 289,
	BOOT_UNKNOWN_CLIENTS = 290,
	NEXT_SERVER = 291,
	TOKEN_RING = 292,
	GROUP = 293,
	ONE_LEASE_PER_CLIENT = 294,
	GET_LEASE_HOSTNAMES = 295,
	USE_HOST_DECL_NAMES = 296,
	SEND = 297,
	CLIENT_IDENTIFIER = 298,
	REQUEST = 299,
	REQUIRE = 300,
	TIMEOUT = 301,
	RETRY = 302,
	SELECT_TIMEOUT = 303,
	SCRIPT = 304,
	INTERFACE = 305,
	RENEW = 306,
	REBIND = 307,
	EXPIRE = 308,
	UNKNOWN_CLIENTS = 309,
	ALLOW = 310,
	DENY = 312,
	BOOTING = 313,
	DEFAULT = 314,
	MEDIA = 315,
	MEDIUM = 316,
	ALIAS = 317,
	REBOOT = 318,
	TOKEN_ABANDONED = 319,
	BACKOFF_CUTOFF = 320,
	INITIAL_INTERVAL = 321,
	NAMESERVER = 322,
	DOMAIN = 323,
	SEARCH = 324,
	SUPERSEDE = 325,
	APPEND = 326,
	PREPEND = 327,
	HOSTNAME = 328,
	CLIENT_HOSTNAME = 329,
	REJECT = 330,
	USE_LEASE_ADDR_FOR_DEFAULT_ROUTE = 331,
	MIN_LEASE_TIME = 332,
	MIN_SECS = 333,
	AND = 334,
	OR = 335,
	SUBSTRING = 337,
	SUFFIX = 338,
	CHECK = 339,
	EXTRACT_INT = 340,
	IF = 341,
	TOKEN_ADD = 342,
	BREAK = 343,
	ELSE = 344,
	ELSIF = 345,
	SUBCLASS = 346,
	MATCH = 347,
	SPAWN = 348,
	WITH = 349,
	EXISTS = 350,
	POOL = 351,
	UNKNOWN = 352,
	CLIENTS = 353,
	KNOWN = 354,
	AUTHENTICATED = 355,
	UNAUTHENTICATED = 356,
	ALL = 357,
	DYNAMIC = 358,
	MEMBERS = 359,
	OF = 360,
	PSEUDO = 361,
	LIMIT = 362,
	BILLING = 363,
	PEER = 364,
	FAILOVER = 365,
	MY = 366,
	PARTNER = 367,
	PRIMARY = 368,
	SECONDARY = 369,
	IDENTIFIER = 370,
	PORT = 371,
	MAX_TRANSMIT_IDLE = 372,
	MAX_RESPONSE_DELAY = 373,
	PARTNER_DOWN = 374,
	NORMAL = 375,
	COMMUNICATIONS_INTERRUPTED = 376,
	POTENTIAL_CONFLICT = 377,
	RECOVER = 378,
	FDDI = 379,
	AUTHORITATIVE = 380,
	TOKEN_NOT = 381,
	AUTHENTICATION = 383,
	IGNORE = 384,
	ACCEPT = 385,
	PREFER = 386,
	DONT = 387,
	CODE = 388,
	ARRAY = 389,
	BOOLEAN = 390,
	INTEGER = 391,
	SIGNED = 392,
	UNSIGNED = 393,
	IP_ADDRESS = 394,
	TEXT = 395,
	STRING_TOKEN = 396,
	SPACE = 397,
	CONCAT = 398,
	ENCODE_INT = 399,
	REVERSE = 402,
	LEASED_ADDRESS = 403,
	BINARY_TO_ASCII = 404,
	PICK = 405,
	CONFIG_OPTION = 406,
	HOST_DECL_NAME = 407,
	ON = 408,
	EXPIRY = 409,
	RELEASE = 410,
	COMMIT = 411,
	DNS_UPDATE = 412,
	LEASE_TIME = 413,
	STATIC = 414,
	NEVER = 415,
	INFINITE = 416,
	TOKEN_DELETED = 417,
	UPDATED_DNS_RR = 418,
	DNS_DELETE = 419,
	DUPLICATES = 420,
	DECLINES = 421,
	TSTP = 422,
	TSFP = 423,
	OWNER = 424,
	IS = 425,
	HBA = 426,
	MAX_UNACKED_UPDATES = 427,
	MCLT = 428,
	SPLIT = 429,
	AT = 430,
	NO = 431,
	TOKEN_DELETE = 432,
	NS_UPDATE = 433,
	UPDATE = 434,
	SWITCH = 435,
	CASE = 436,
	NS_FORMERR = 437,
	NS_NOERROR = 438,
	NS_NOTAUTH = 439,
	NS_NOTIMP = 440,
	NS_NOTZONE = 441,
	NS_NXDOMAIN = 442,
	NS_NXRRSET = 443,
	NS_REFUSED = 444,
	NS_SERVFAIL = 445,
	NS_YXDOMAIN = 446,
	NS_YXRRSET = 447,
	TOKEN_NULL = 448,
	TOKEN_SET = 449,
	DEFINED = 450,
	UNSET = 451,
	EVAL = 452,
	LET = 453,
	FUNCTION = 454,
	DEFINE = 455,
	ZONE = 456,
	KEY = 457,
	SECRET = 458,
	ALGORITHM = 459,
	LOAD = 460,
	BALANCE = 461,
	TOKEN_MAX = 462,
	SECONDS = 463,
	ADDRESS = 464,
	RESOLUTION_INTERRUPTED = 465,
	STATE = 466,
	UNKNOWN_STATE = 567,
	CLTT = 568,
	INCLUDE = 569,
	BINDING = 570,
	TOKEN_FREE = 571,
	TOKEN_ACTIVE = 572,
	TOKEN_EXPIRED = 573,
	TOKEN_RELEASED = 574,
	TOKEN_RESET = 575,
	TOKEN_BACKUP = 576,
	TOKEN_RESERVED = 577,
	TOKEN_BOOTP = 578,
	TOKEN_NEXT = 579,
	OMAPI = 580,
	LOG = 581,
	FATAL = 582,
	ERROR = 583,
	TOKEN_DEBUG = 584,
	INFO = 585,
	RETURN = 586,
	PAUSED = 587,
	RECOVER_DONE = 588,
	SHUTDOWN = 589,
	STARTUP = 590,
	ENCAPSULATE = 591,
	VENDOR = 592,
	CLIENT_STATE = 593,
	INIT_REBOOT = 594,
	TOKEN_INIT = 595,
	SELECT = 596,
	BOUND = 597,
	RENEWING = 598,
	REBINDING = 599,
	RECONTACT_INTERVAL = 600,
	CLIENT_UPDATES = 601,
	TOKEN_NEW = 601,
	TRANSMISSION = 602,
	TOKEN_CLOSE = 603,
	TOKEN_CREATE = 604,
	TOKEN_OPEN = 605,
	TOKEN_HELP = 606,
	END_OF_FILE = 607,
	RECOVER_WAIT = 608,
	SERVER = 609,
	CONNECT = 610,
	REMOVE = 611,
	REFRESH = 612,
	DOMAIN_NAME = 613,
	DO_FORWARD_UPDATE = 614
};

#define is_identifier(x)	((x) >= FIRST_TOKEN &&	\
				 (x) != STRING &&	\
				 (x) != NUMBER &&	\
				 (x) != END_OF_FILE)
