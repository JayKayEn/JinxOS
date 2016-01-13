#include <lib.h>
#include <thread.h>
#include <threadlist.h>
#include <test.h>
#include <kmm.h>

#define NUMNAMES 7
static const char *const names[NUMNAMES] = {
    "Aillard",
    "Aldaran",
    "Alton",
    "Ardais",
    "Elhalyn",
    "Hastur",
    "Ridenow",
};

static struct thread *fakethreads[NUMNAMES];

////////////////////////////////////////////////////////////
// fakethread

#define FAKE_MAGIC ((void*) 0xbaabaa)

/*
 * Create a dummy struct thread that we can put on lists for testing.
 */
static
struct thread *
fakethread_create(const char *name) {
    struct thread *t;

    t = kmalloc(sizeof(*t));
    if (t == NULL) {
        panic("threadlisttest: Out of memory\n");
    }
    /* ignore most of the fields, zero everything for tidiness */
    memset(t, 0, sizeof(*t));
    t->name = strdup(name);
    if (t->name == NULL) {
        panic("threadlisttest: Out of memory\n");
    }
    t->stack = FAKE_MAGIC;
    threadlistnode_init(&t->listnode, t);
    return t;
}

/*
 * Destroy a fake thread.
 */
static
void
fakethread_destroy(struct thread *t) {
    assert(t->stack == FAKE_MAGIC);
    threadlistnode_cleanup(&t->listnode);
    kfree(t->name);
    kfree(t);
}

////////////////////////////////////////////////////////////
// support stuff

static
void
check_order(struct threadlist *tl, bool rev) {
    const char string0[] = "...";
    const char stringN[] = "~~~";

    struct thread *t;
    const char *first = rev ? stringN : string0;
    const char *last = rev ? string0 : stringN;
    const char *prev;
    int cmp;

    prev = first;
    THREADLIST_FORALL(t, *tl) {
        cmp = strcmp(prev, t->name);
        assert(rev ? (cmp > 0) : (cmp < 0));
        prev = t->name;
    }
    cmp = strcmp(prev, last);
    assert(rev ? (cmp > 0) : (cmp < 0));
}

////////////////////////////////////////////////////////////
// tests

static
void
threadlisttest_a(void) {
    struct threadlist tl;

    threadlist_init(&tl);
    assert(threadlist_isempty(&tl));
    threadlist_cleanup(&tl);
}

static
void
threadlisttest_b(void) {
    struct threadlist tl;
    struct thread *t;

    threadlist_init(&tl);

    threadlist_addhead(&tl, fakethreads[0]);
    check_order(&tl, false);
    check_order(&tl, true);
    assert(tl.tl_count == 1);
    t = threadlist_remhead(&tl);
    assert(tl.tl_count == 0);
    assert(t == fakethreads[0]);

    threadlist_addtail(&tl, fakethreads[0]);
    check_order(&tl, false);
    check_order(&tl, true);
    assert(tl.tl_count == 1);
    t = threadlist_remtail(&tl);
    assert(tl.tl_count == 0);
    assert(t == fakethreads[0]);

    threadlist_cleanup(&tl);
}

static
void
threadlisttest_c(void) {
    struct threadlist tl;
    struct thread *t;

    threadlist_init(&tl);

    threadlist_addhead(&tl, fakethreads[0]);
    threadlist_addhead(&tl, fakethreads[1]);
    assert(tl.tl_count == 2);

    check_order(&tl, true);

    t = threadlist_remhead(&tl);
    assert(t == fakethreads[1]);
    t = threadlist_remhead(&tl);
    assert(t == fakethreads[0]);
    assert(tl.tl_count == 0);

    threadlist_addtail(&tl, fakethreads[0]);
    threadlist_addtail(&tl, fakethreads[1]);
    assert(tl.tl_count == 2);

    check_order(&tl, false);

    t = threadlist_remtail(&tl);
    assert(t == fakethreads[1]);
    t = threadlist_remtail(&tl);
    assert(t == fakethreads[0]);
    assert(tl.tl_count == 0);

    threadlist_cleanup(&tl);
}

static
void
threadlisttest_d(void) {
    struct threadlist tl;
    struct thread *t;

    threadlist_init(&tl);

    threadlist_addhead(&tl, fakethreads[0]);
    threadlist_addtail(&tl, fakethreads[1]);
    assert(tl.tl_count == 2);

    check_order(&tl, false);

    t = threadlist_remhead(&tl);
    assert(t == fakethreads[0]);
    t = threadlist_remtail(&tl);
    assert(t == fakethreads[1]);
    assert(tl.tl_count == 0);

    threadlist_addhead(&tl, fakethreads[0]);
    threadlist_addtail(&tl, fakethreads[1]);
    assert(tl.tl_count == 2);

    check_order(&tl, false);

    t = threadlist_remtail(&tl);
    assert(t == fakethreads[1]);
    t = threadlist_remtail(&tl);
    assert(t == fakethreads[0]);
    assert(tl.tl_count == 0);

    threadlist_cleanup(&tl);
}

static
void
threadlisttest_e(void) {
    struct threadlist tl;
    struct thread *t;
    unsigned i;

    threadlist_init(&tl);

    threadlist_addhead(&tl, fakethreads[1]);
    threadlist_addtail(&tl, fakethreads[3]);
    assert(tl.tl_count == 2);
    check_order(&tl, false);

    threadlist_insertafter(&tl, fakethreads[3], fakethreads[4]);
    assert(tl.tl_count == 3);
    check_order(&tl, false);

    threadlist_insertbefore(&tl, fakethreads[0], fakethreads[1]);
    assert(tl.tl_count == 4);
    check_order(&tl, false);

    threadlist_insertafter(&tl, fakethreads[1], fakethreads[2]);
    assert(tl.tl_count == 5);
    check_order(&tl, false);

    assert(fakethreads[4]->listnode.tln_prev->tln_self ==
            fakethreads[3]);
    assert(fakethreads[3]->listnode.tln_prev->tln_self ==
            fakethreads[2]);
    assert(fakethreads[2]->listnode.tln_prev->tln_self ==
            fakethreads[1]);
    assert(fakethreads[1]->listnode.tln_prev->tln_self ==
            fakethreads[0]);

    for (i=0; i<5; i++) {
        t = threadlist_remhead(&tl);
        assert(t == fakethreads[i]);
    }
    assert(tl.tl_count == 0);

    threadlist_cleanup(&tl);
}

static
void
threadlisttest_f(void) {
    struct threadlist tl;
    struct thread *t;
    unsigned i;

    threadlist_init(&tl);

    for (i=0; i<NUMNAMES; i++) {
        threadlist_addtail(&tl, fakethreads[i]);
    }
    assert(tl.tl_count == NUMNAMES);

    i=0;
    THREADLIST_FORALL(t, tl) {
        assert(t == fakethreads[i]);
        i++;
    }
    assert(i == NUMNAMES);

    i=0;
    THREADLIST_FORALL_REV(t, tl) {
        assert(t == fakethreads[NUMNAMES - i - 1]);
        i++;
    }
    assert(i == NUMNAMES);

    for (i=0; i<NUMNAMES; i++) {
        t = threadlist_remhead(&tl);
        assert(t == fakethreads[i]);
    }
    assert(tl.tl_count == 0);
}

////////////////////////////////////////////////////////////
// external interface

int
threadlisttest(int nargs, char **args) {
    unsigned i;

    (void)nargs;
    (void)args;

    print("Testing threadlists...\n");

    for (i=0; i<NUMNAMES; i++) {
        fakethreads[i] = fakethread_create(names[i]);
    }

    threadlisttest_a();
    threadlisttest_b();
    threadlisttest_c();
    threadlisttest_d();
    threadlisttest_e();
    threadlisttest_f();

    for (i=0; i<NUMNAMES; i++) {
        fakethread_destroy(fakethreads[i]);
        fakethreads[i] = NULL;
    }

    print("Done.\n");
    return 0;
}
