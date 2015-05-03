#!/usr/bin/perl

{ package Object;
  sub typeName;
  sub add ($$) {
      my ($a, $b) = @_;
      my $ta = $a->typeName();
      my $tb = $b->typeName();
      $promo{Scalar}{Scalar} = 'Scalar';
      $promo{Scalar}{Polynomial} = 'Polynomial';
      $promo{Scalar}{Factoring} = 'Polynomial';
      $promo{Scalar}{Variable} = 'Polynomial';
      $promo{Polynomial}{Scalar} = 'Polynomial';
      $promo{Polynomial}{Polynomial} = 'Polynomial';
      $promo{Polynomial}{Factoring} = 'Polynomial';
      $promo{Polynomial}{Variable} = 'Polynomial';
      $promo{Factoring}{Scalar} = 'Polynomial';
      $promo{Factoring}{Polynomial} = 'Polynomial';
      $promo{Factoring}{Factoring} = 'Polynomial';
      $promo{Factoring}{Variable} = 'Polynomial';
      $promo{Variable}{Scalar} = 'Polynomial';
      $promo{Variable}{Polynomial} = 'Polynomial';
      $promo{Variable}{Factoring} = 'Polynomial';
      $promo{Variable}{Variable} = 'Polynomial';
      my $tr = $promo{$a->typeName()}{$b->typeName()};
      printf ("Add: left=%s right=%s result=%s\n", $ta, $tb, $tr);
      if ($ta ne $tr) { printf ("  Add Need to change $ta to $tr\n"); }
      if ($tb ne $tr) { printf ("  Add Need to change $tb to $tr\n"); }
  }
  sub mul ($$) {
      my ($a, $b) = @_;
      my $ta = $a->typeName();
      my $tb = $b->typeName();
      $promo{Scalar}{Scalar} = 'Scalar';
      $promo{Scalar}{Polynomial} = 'Polynomial';
      $promo{Scalar}{Factoring} = 'Factoring';
      $promo{Scalar}{Variable} = 'Polynomial';
      $promo{Polynomial}{Scalar} = 'Polynomial';
      $promo{Polynomial}{Polynomial} = 'Polynomial';
      $promo{Polynomial}{Factoring} = 'Polynomial';
      $promo{Polynomial}{Variable} = 'Polynomial';
      $promo{Factoring}{Scalar} = 'Factoring';
      $promo{Factoring}{Polynomial} = 'Polynomial';
      $promo{Factoring}{Factoring} = 'Factoring';
      $promo{Factoring}{Variable} = 'Factoring';
      $promo{Variable}{Scalar} = 'Polynomial';
      $promo{Variable}{Polynomial} = 'Polynomial';
      $promo{Variable}{Factoring} = 'Factoring';
      $promo{Variable}{Variable} = 'Polynomial';
      my $tr = $promo{$a->typeName()}{$b->typeName()};
      printf ("Mul: left=%s right=%s result=%s\n", $ta, $tb, $tr);
      if ($ta ne $tr) { printf ("  Mul Need to change $ta to $tr\n"); }
      if ($tb ne $tr) { printf ("  Mul Need to change $tb to $tr\n"); }
  }
}

{ package Scalar;
  @ISA = qw{Object};
  sub new () {
      my ($class) = @_;
      my $self = {};
      bless $self, $class;
      return $self;
  }
  sub typeName () { return "Scalar"; }
}

{ package Polynomial;
  @ISA = qw{Object};
  sub new () {
      my ($class) = @_;
      my $self = {};
      bless $self, $class;
      return $self;
  }
  sub typeName () { return "Polynomial"; }
}

{ package Factoring;
  @ISA = qw{Object};
  sub new () {
      my ($class) = @_;
      my $self = {};
      bless $self, $class;
      return $self;
  }
  sub typeName () { return "Factoring"; }
}

{ package Variable;
  @ISA = qw{Object};
  sub new () {
      my ($class) = @_;
      my $self = {};
      bless $self, $class;
      return $self;
  }
  sub typeName () { return "Variable"; }
}

# Test
my $t1 = Scalar->new();
my $t3 = Polynomial->new();
my $t4 = Factoring->new();
my $t2 = Variable->new();

for $a ($t1, $t2, $t3, $t4) {
    for $b ($t1, $t2, $t3, $t4) {
	my $c=Object::add($a, $b);
    }
}
for $a ($t1, $t2, $t3, $t4) {
    for $b ($t1, $t2, $t3, $t4) {
	my $c=Object::mul($a, $b);
    }
}

