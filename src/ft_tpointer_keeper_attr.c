/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_tpointer_keeper_attr.c                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: fcodi <fcodi@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/01/04 13:55:07 by fcodi             #+#    #+#             */
/*   Updated: 2020/02/06 18:02:53 by fcodi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_tpointer_keeper.h"

void 				init_tpointer_keeper_attr(t_pointer_keeper_attr *attr)
{
	attr->pointer_count = 0;
	attr->destroy_ptr = FALSE;
	attr->add_null_ptr = FALSE;
	attr->destroy_on_error = TRUE;
	attr->ignore_pointer_count_when_destroy = TRUE;
	attr->destroy_added_matrix = TRUE;
}

void 				calc_tpointer_count(t_pointer_keeper *keeper)
{
	if (!keeper || !keeper->head)
		return ;
	keeper->attr.pointer_count = 1;
	keeper->current = keeper->head;
	while (keeper->current->next && (keeper->current = keeper->current->next))
		keeper->attr.pointer_count++;
}

t_pointer_keeper_attr	*get_default_tpointer_keeper_attr(void)
{
	t_pointer_keeper_attr	*attr;

	if (!(attr =
				  (t_pointer_keeper_attr *)malloc(sizeof(t_pointer_keeper_attr))))
		return (NULL);
	init_tpointer_keeper_attr(attr);
	return (attr);
}
