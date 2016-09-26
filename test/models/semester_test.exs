defmodule Klausurenarchiv.SemesterTest do
    use ExUnit.Case

    alias Klausurenarchiv.Semester

    @valid_attrs %{kind: "WiSe", year: "14/15"}

    test "Semester.from_string" do
        sem = %Semester{kind: "WiSe", year: "14/15"}

        assert Semester.from_string("WiSe 14/15") == sem
    end

    test "to_string" do
        sem = %Semester{kind: "WiSe", year: "14/15"}
        
        assert to_string(sem) == "WiSe 14/15"
    end

    test "Semester.compare_strings" do
        assert Semester.compare_strings("SoSe 17", "WiSe 18/19")
        refute Semester.compare_strings("SoSe 17", "WiSe 16/17")
        assert Semester.compare_strings("WiSe 17/18", "WiSe 18/19")
        refute Semester.compare_strings("WiSe 18/19", "SoSe 17")
    end
end
