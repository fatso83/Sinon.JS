"use strict";
const { it, describe } = (exports.lab = require("@hapi/lab").script());
const sinon = require("sinon");
const referee = require("@sinonjs/referee");
const assert = referee.assert;

describe("stub", () => {
    it("should define new setter", () => {
        const myObj = {
            example: "oldValue",
            prop: "foo"
        };

        sinon.stub(myObj, "prop").set(function setterFn(val) {
            myObj.example = val;
        });

        myObj.prop = "baz";

        assert.equals(myObj.example, "baz");
    });
});
