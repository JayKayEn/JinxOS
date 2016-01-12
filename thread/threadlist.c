#include <lib.h>
#include <thread.h>
#include <threadlist.h>

void
threadlistnode_init(struct threadlistnode* tln, struct thread* t) {
    assert(tln != NULL);
    assert(t != NULL);

    tln->tln_next = NULL;
    tln->tln_prev = NULL;
    tln->tln_self = t;
}

void
threadlistnode_cleanup(struct threadlistnode* tln) {
    assert(tln != NULL);

    assert(tln->tln_next == NULL);
    assert(tln->tln_prev == NULL);
    assert(tln->tln_self != NULL);
}

void
threadlist_init(struct threadlist* tl) {
    assert(tl != NULL);

    tl->tl_head.tln_next = &tl->tl_tail;
    tl->tl_head.tln_prev = NULL;
    tl->tl_tail.tln_next = NULL;
    tl->tl_tail.tln_prev = &tl->tl_head;
    tl->tl_head.tln_self = NULL;
    tl->tl_tail.tln_self = NULL;
    tl->tl_count = 0;
}

void
threadlist_cleanup(struct threadlist* tl) {
    assert(tl != NULL);
    assert(tl->tl_head.tln_next == &tl->tl_tail);
    assert(tl->tl_head.tln_prev == NULL);
    assert(tl->tl_tail.tln_next == NULL);
    assert(tl->tl_tail.tln_prev == &tl->tl_head);
    assert(tl->tl_head.tln_self == NULL);
    assert(tl->tl_tail.tln_self == NULL);

    assert(threadlist_isempty(tl));
    assert(tl->tl_count == 0);

    /* nothing (else) to do */
}

bool
threadlist_isempty(struct threadlist* tl) {
    assert(tl != NULL);

    return (tl->tl_count == 0);
}

////////////////////////////////////////////////////////////
// internal

/*
 * Do insertion. Doesn't update tl_count.
 */
static
void
threadlist_insertafternode(struct threadlistnode* onlist, struct thread* t) {
    struct threadlistnode* addee;

    addee = &t->listnode;

    assert(addee->tln_prev == NULL);
    assert(addee->tln_next == NULL);

    addee->tln_prev = onlist;
    addee->tln_next = onlist->tln_next;
    addee->tln_prev->tln_next = addee;
    addee->tln_next->tln_prev = addee;
}

/*
 * Do insertion. Doesn't update tl_count.
 */
static
void
threadlist_insertbeforenode(struct thread* t, struct threadlistnode* onlist) {
    struct threadlistnode* addee;

    addee = &t->listnode;

    assert(addee->tln_prev == NULL);
    assert(addee->tln_next == NULL);

    addee->tln_prev = onlist->tln_prev;
    addee->tln_next = onlist;
    addee->tln_prev->tln_next = addee;
    addee->tln_next->tln_prev = addee;
}

/*
 * Do removal. Doesn't update tl_count.
 */
static
void
threadlist_removenode(struct threadlistnode* tln) {
    assert(tln != NULL);
    assert(tln->tln_prev != NULL);
    assert(tln->tln_next != NULL);

    tln->tln_prev->tln_next = tln->tln_next;
    tln->tln_next->tln_prev = tln->tln_prev;
    tln->tln_prev = NULL;
    tln->tln_next = NULL;
}

////////////////////////////////////////////////////////////
// public

void
threadlist_addhead(struct threadlist* tl, struct thread* t) {
    assert(tl != NULL);
    assert(t != NULL);

    threadlist_insertafternode(&tl->tl_head, t);
    tl->tl_count++;
}

void
threadlist_addtail(struct threadlist* tl, struct thread* t) {
    assert(tl != NULL);
    assert(t != NULL);

    threadlist_insertbeforenode(t, &tl->tl_tail);
    tl->tl_count++;
}

struct thread*
threadlist_remhead(struct threadlist* tl) {
    struct threadlistnode* tln;

    assert(tl != NULL);

    tln = tl->tl_head.tln_next;
    if (tln->tln_next == NULL)
        return NULL;

    threadlist_removenode(tln);
    assert(tl->tl_count > 0);
    tl->tl_count--;
    return tln->tln_self;
}

struct thread*
threadlist_remtail(struct threadlist* tl) {
    struct threadlistnode* tln;

    assert(tl != NULL);

    tln = tl->tl_tail.tln_prev;
    if (tln->tln_prev == NULL)
        return NULL;

    threadlist_removenode(tln);
    assert(tl->tl_count > 0);
    tl->tl_count--;
    return tln->tln_self;
}

void
threadlist_insertafter(struct threadlist* tl,
                       struct thread* onlist, struct thread* addee) {
    threadlist_insertafternode(&onlist->listnode, addee);
    tl->tl_count++;
}

void
threadlist_insertbefore(struct threadlist* tl,
                        struct thread* addee, struct thread* onlist) {
    threadlist_insertbeforenode(addee, &onlist->listnode);
    tl->tl_count++;
}

void
threadlist_remove(struct threadlist* tl, struct thread* t) {
    threadlist_removenode(&t->listnode);
    assert(tl->tl_count > 0);
    tl->tl_count--;
}
