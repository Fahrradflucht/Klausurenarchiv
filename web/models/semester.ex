defmodule Klausurenarchiv.Semester do
    @enforce_keys [:kind, :year]
    defstruct [:kind, :year]
    @type t :: %Klausurenarchiv.Semester{kind: String.t, year: String.t}

    def from_string(str) do
        [kind, year] = String.split(str)
        %Klausurenarchiv.Semester{kind: kind, year: year}
    end

    def compare_strings(a, b) do
        a_sem = from_string(a)
        b_sem = from_string(b)

        [a_sem.year, b_sem.year] == Enum.sort([a_sem.year, b_sem.year])
    end
end

defimpl String.Chars, for: Klausurenarchiv.Semester do
    def to_string(term) do
        "#{term.kind} #{term.year}"
    end
end