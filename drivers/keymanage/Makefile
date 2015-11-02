#
# (C) Copyright 2000-2007
# Wolfgang Denk, DENX Software Engineering, wd@denx.de.
#
# See file CREDITS for list of people who contributed to this
# project.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307 USA
#

obj-$(CONFIG_UNIFY_KEY_MANAGE) += aml_key_manage.o

aml_key_manage-y 						 		= key_unify.o
aml_key_manage-y 						 	   += key_manage.o
aml_key_manage-$(CONFIG_OF_LIBFDT) 				+= km_dts.o
aml_key_manage-$(CONFIG_AML_SECURITY_KEY) 		+= km_secure_key.o
aml_key_manage-$(CONFIG_EFUSE) 					+= km_efuse_key.o

