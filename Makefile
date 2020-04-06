# -----------------------------------------------------------------------------
#  General
# -----------------------------------------------------------------------------

NAME ?= libft.a

WARNING_SUPPRESS_FLAGS = -Wall -Wextra -Werror

override CC = gcc

PROJECT_PATH ?= $(CURDIR)

# -----------------------------------------------------------------------------
#  Platform specific
# -----------------------------------------------------------------------------

OS ?= $(shell uname 2>/dev/null || echo Unknown)

ifeq ($(OS),Unknown)
$(error Unsupported OS)
endif

# -----------------------------------------------------------------------------
#  Include
# -----------------------------------------------------------------------------

INCLUDE_DIR ?= include

INCLUDE_PATH ?= $(INCLUDE_PATH_FIND)

INCLUDE_PATH_FIND != find $(PROJECT_PATH)/$(INCLUDE_DIR) -type d

INCLUDE_FLAGS ?= $(addprefix -I,$(INCLUDE_PATH))

INCLUDE_FILES ?= ft_string.h

# -----------------------------------------------------------------------------
#  Source
# -----------------------------------------------------------------------------

SOURCE_DIR ?= src

SOURCE_PATH ?= $(SOURCE_PATH_FIND)

SOURCE_PATH_FIND != find $(PROJECT_PATH)/$(SOURCE_DIR) -type d

SOURCE_FILES ?= ft_uintlen.c \
                ft_strjoin.c \
                ft_strmap.c \
                ft_strncpy.c \
                ft_strcpy.c \
                ft_strlenc.c \
                ft_strchr.c \
                ft_strnstr.c \
                ft_strsub.c \
                ft_strrchr.c \
                ft_strncat.c \
                ft_strcmp.c \
                ft_strlcat.c \
                ft_strnlen.c \
                ft_strcat.c \
                ft_strmapi.c \
                ft_strnequ.c \
                ft_strlen.c \
                ft_strdup.c \
                ft_strclr.c \
                ft_strstr.c \
                ft_strsplit.c \
                ft_strdel.c \
                ft_strnew.c \
                ft_strequ.c \
                ft_striter.c \
                ft_striteri.c \
                ft_strncmp.c \
                ft_strtrim.c \
                ft_isalpha.c \
                ft_isdigit.c \
                ft_isalnum.c \
                ft_isspace.c \
                ft_isprint.c \
                ft_islower.c \
                ft_isupper.c \
                ft_isascii.c \
                ft_lstiter.c \
                ft_lstdel.c \
                ft_lstadd.c \
                ft_lstdelone.c \
                ft_lstmap.c \
                ft_lstnew.c \
                ft_putstr_fd.c \
                ft_putstr.c \
                ft_putchar.c \
                ft_putnbr_fd.c \
                ft_putendl_fd.c \
                ft_putnbr.c \
                ft_putendl.c \
                ft_putchar_fd.c \
                ft_memccpy.c \
                ft_memcpy.c \
                ft_bzero.c \
                ft_memset.c \
                ft_memcmp.c \
                ft_memchr.c \
                ft_memdel.c \
                ft_memalloc.c \
                ft_memmove.c \
                ft_tolower.c \
                ft_toupper.c \
                ft_itoa.c \
                ft_atoi.c \
                ft_astrdel.c

# -----------------------------------------------------------------------------
#  Object
# -----------------------------------------------------------------------------

OBJECT_DIR ?= obj

OBJECT_PATH_EXIST ?= $(OBJECT_PATH)/.exist

OBJECT_PATH ?= $(PROJECT_PATH)/$(OBJECT_DIR)

OBJECT_FILES ?= $(SOURCE_FILES:.c=.o)

# -----------------------------------------------------------------------------
#  Library
# -----------------------------------------------------------------------------

ifneq ($(LIBRARY_FILES),)

_LIBRARY_PATH = $(sort $(filter-out ./ ., $(dir $(LIBRARY_FILES)) \
	$(LIBRARY_PATH)))

_LIBRARY_FILES = $(notdir $(filter %.a %.so,$(LIBRARY_FILES)))
ifeq ($(OS),Darwin)
_LIBRARY_FILES += $(notdir $(filter %.dylib,$(LIBRARY_FILES)))
endif

LIBRARY_FLAGS = $(addprefix -l,$(sort $(basename $(_LIBRARY_FILES:lib%=%)))) \
	$(addprefix -L,$(_LIBRARY_PATH))

endif

# -----------------------------------------------------------------------------
#  GCC flags
# -----------------------------------------------------------------------------

ifeq ($(OS),Darwin)
override ARFLAGS = rcs
else ifeq ($(OS),Linux)
override ARFLAGS = rcsU
endif

ifneq ($(CFLAGS),$(WARNING_SUPPRESS_FLAGS))
override CFLAGS += $(WARNING_SUPPRESS_FLAGS)
endif
ifneq ($(CPPFLAGS),$(INCLUDE_FLAGS))
override CPPFLAGS += $(sort $(INCLUDE_FLAGS))
endif
ifneq ($(LDFLAGS),$(LIBRARY_FLAGS))
override LDFLAGS += $(sort $(LIBRARY_FLAGS))
endif

# -----------------------------------------------------------------------------
#  Rules
# -----------------------------------------------------------------------------

all: $(NAME)

ifeq ($(notdir $(CURDIR)),$(OBJECT_DIR))

ifeq ($(suffix $(NAME)),.a)
$(NAME): $(OBJECT_FILES) $(INCLUDE_FILES) $(NAME)($(OBJECT_FILES))
else
$(NAME): private BINFLAGS = $(sort $(CFLAGS) $(CPPFLAGS) $(LDFLAGS))
$(NAME): $(OBJECT_FILES) $(INCLUDE_FILES)
	$(CC) $^ $(BINFLAGS) -o $@
endif

else

export
$(NAME): $(SOURCE_FILES) $(INCLUDE_FILES) | $(OBJECT_PATH_EXIST)
	$(MAKE) --makefile="$(CURDIR)/Makefile" \
	--directory="$(OBJECT_PATH)" \
	NAME="$(PROJECT_PATH)/$(NAME)"

endif

%.exist:
	-mkdir $(@D)
	-touch $@

clean:
	$(RMDIR) $(OBJECT_PATH)

fclean: clean
	$(RM) $(NAME)

re: fclean all

# -----------------------------------------------------------------------------
#  Special rules and definitions
# -----------------------------------------------------------------------------

EMPTY :=

SPACE :=
SPACE +=

RMDIR = $(RM)r

.PHONY: all re clean fclean libft

.SECONDARY: $(OBJECT_FILES)

.DEFAULT: all

vpath %.c $(SOURCE_PATH)
vpath %.h $(INCLUDE_PATH)
vpath %.o $(OBJECT_PATH)
vpath %.a $(_LIBRARY_PATH)
vpath %.so $(_LIBRARY_PATH)
ifeq ($(OS),Darwin)
vpath %.dylib $(_LIBRARY_PATH)
endif